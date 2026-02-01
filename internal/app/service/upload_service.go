package service

import (
	"bytes"
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"io"
	"log/slog"
	"os"
	"path/filepath"
	"sync"

	"github.com/google/uuid"

	"github.com/carlosealves2/FileGuardian/internal/domain"
	"github.com/carlosealves2/FileGuardian/internal/domain/entity"
	"github.com/carlosealves2/FileGuardian/internal/domain/valueobject"
	"github.com/carlosealves2/FileGuardian/internal/ports/driven"
	"github.com/carlosealves2/FileGuardian/internal/ports/driving"
)

type UploadService struct {
	processRepo     driven.ProcessRepository
	uploadRepo      driven.UploadRepository
	storageResolver driven.StorageResolver
	logger          *slog.Logger
	partSize        int64
	maxWorkers      int32
	partsParallel   int32

	mu          sync.Mutex
	cancelFuncs map[string]context.CancelFunc
}

type partResult struct {
	part valueobject.CompletedPart
	err  error
}

func NewUploadService(
	processRepo driven.ProcessRepository,
	uploadRepo driven.UploadRepository,
	storageResolver driven.StorageResolver,
	logger *slog.Logger,
	partSize int64,
	maxWorkers int32,
	partsParallel int32,
) *UploadService {
	return &UploadService{
		processRepo:     processRepo,
		uploadRepo:      uploadRepo,
		storageResolver: storageResolver,
		logger:          logger,
		partSize:        partSize,
		maxWorkers:      maxWorkers,
		partsParallel:   partsParallel,
		cancelFuncs:     make(map[string]context.CancelFunc),
	}
}

func (s *UploadService) UploadFile(ctx context.Context, filePath string, progressCh chan<- driving.UploadProgress) error {
	defer close(progressCh)

	storage, err := s.storageResolver.Resolve(ctx)
	if err != nil {
		return fmt.Errorf("resolving storage: %w", err)
	}

	info, err := os.Stat(filePath)
	if err != nil {
		return fmt.Errorf("stating file: %w", err)
	}
	if info.IsDir() {
		return fmt.Errorf("%w: path is a directory, use UploadFolder", domain.ErrInvalidInput)
	}

	checksum, err := computeSHA256(filePath)
	if err != nil {
		return fmt.Errorf("computing checksum: %w", err)
	}

	process := entity.NewProcess(uuid.NewString(), valueobject.ProcessTypeFile, storage.Provider(), filePath)
	if err := s.processRepo.Create(ctx, process); err != nil {
		return fmt.Errorf("creating process: %w", err)
	}

	storageKey := filepath.Base(filePath)
	upload := entity.NewUpload(uuid.NewString(), process.ID, filePath, storageKey, info.Size(), checksum)
	if err := s.uploadRepo.Create(ctx, upload); err != nil {
		return fmt.Errorf("creating upload: %w", err)
	}

	uploadCtx, cancel := context.WithCancel(ctx)
	s.registerCancel(process.ID, cancel)
	defer s.unregisterCancel(process.ID)

	if err := process.TransitionTo(valueobject.StatusInProgress); err != nil {
		return fmt.Errorf("transitioning process to in-progress: %w", err)
	}
	if err := s.processRepo.Update(ctx, process); err != nil {
		return fmt.Errorf("updating process: %w", err)
	}

	if err := s.executeUpload(uploadCtx, storage, &upload, progressCh); err != nil {
		return err
	}

	uploads, err := s.uploadRepo.ListByProcessID(ctx, process.ID)
	if err != nil {
		return fmt.Errorf("listing uploads: %w", err)
	}
	newStatus := entity.DeriveProcessStatus(uploads)
	if err := process.TransitionTo(newStatus); err != nil {
		return fmt.Errorf("transitioning process: %w", err)
	}
	if err := s.processRepo.Update(ctx, process); err != nil {
		return fmt.Errorf("updating process: %w", err)
	}

	return nil
}

func (s *UploadService) UploadFolder(ctx context.Context, folderPath string, progressCh chan<- driving.UploadProgress) error {
	defer close(progressCh)

	storage, err := s.storageResolver.Resolve(ctx)
	if err != nil {
		return fmt.Errorf("resolving storage: %w", err)
	}

	info, err := os.Stat(folderPath)
	if err != nil {
		return fmt.Errorf("stating folder: %w", err)
	}
	if !info.IsDir() {
		return fmt.Errorf("%w: path is not a directory", domain.ErrInvalidInput)
	}

	process := entity.NewProcess(uuid.NewString(), valueobject.ProcessTypeFolder, storage.Provider(), folderPath)
	if err := s.processRepo.Create(ctx, process); err != nil {
		return fmt.Errorf("creating process: %w", err)
	}

	var files []string
	err = filepath.Walk(folderPath, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() {
			files = append(files, path)
		}
		return nil
	})
	if err != nil {
		return fmt.Errorf("walking folder: %w", err)
	}

	var uploads []entity.Upload
	for _, filePath := range files {
		fileInfo, err := os.Stat(filePath)
		if err != nil {
			continue
		}

		checksum, err := computeSHA256(filePath)
		if err != nil {
			continue
		}

		relPath, _ := filepath.Rel(folderPath, filePath)
		storageKey := filepath.Join(filepath.Base(folderPath), relPath)

		upload := entity.NewUpload(uuid.NewString(), process.ID, filePath, storageKey, fileInfo.Size(), checksum)
		if err := s.uploadRepo.Create(ctx, upload); err != nil {
			return fmt.Errorf("creating upload: %w", err)
		}
		uploads = append(uploads, upload)
	}

	uploadCtx, cancel := context.WithCancel(ctx)
	s.registerCancel(process.ID, cancel)
	defer s.unregisterCancel(process.ID)

	if err := process.TransitionTo(valueobject.StatusInProgress); err != nil {
		return fmt.Errorf("transitioning process to in-progress: %w", err)
	}
	if err := s.processRepo.Update(ctx, process); err != nil {
		return fmt.Errorf("updating process: %w", err)
	}

	sem := make(chan struct{}, s.maxWorkers)
	var wg sync.WaitGroup

	for i := range uploads {
		wg.Add(1)
		sem <- struct{}{}
		go func(u *entity.Upload) {
			defer wg.Done()
			defer func() { <-sem }()
			if err := s.executeUpload(uploadCtx, storage, u, progressCh); err != nil {
				s.logger.Error("executing upload", "upload_id", u.ID, "error", err)
			}
		}(&uploads[i])
	}
	wg.Wait()

	updatedUploads, err := s.uploadRepo.ListByProcessID(ctx, process.ID)
	if err != nil {
		return fmt.Errorf("listing uploads: %w", err)
	}
	newStatus := entity.DeriveProcessStatus(updatedUploads)
	if err := process.TransitionTo(newStatus); err != nil {
		return fmt.Errorf("transitioning process: %w", err)
	}
	if err := s.processRepo.Update(ctx, process); err != nil {
		return fmt.Errorf("updating process: %w", err)
	}

	return nil
}

func (s *UploadService) PauseProcess(ctx context.Context, processID string) error {
	process, err := s.processRepo.GetByID(ctx, processID)
	if err != nil {
		return err
	}

	if err := process.Pause(); err != nil {
		return err
	}

	// Cancel the context to signal goroutines to stop after current part
	s.mu.Lock()
	if cancel, ok := s.cancelFuncs[processID]; ok {
		cancel()
	}
	s.mu.Unlock()

	// Update uploads that are in progress to paused
	uploads, err := s.uploadRepo.ListByProcessID(ctx, processID)
	if err != nil {
		return err
	}
	for _, u := range uploads {
		if u.Status == valueobject.StatusInProgress {
			if err := u.TransitionTo(valueobject.StatusPaused); err != nil {
				return fmt.Errorf("transitioning upload to paused: %w", err)
			}
			if err := s.uploadRepo.Update(ctx, u); err != nil {
				return fmt.Errorf("updating upload: %w", err)
			}
		}
	}

	if err := s.processRepo.Update(ctx, process); err != nil {
		return fmt.Errorf("updating process: %w", err)
	}
	return nil
}

func (s *UploadService) ResumeProcess(ctx context.Context, processID string, progressCh chan<- driving.UploadProgress) error {
	defer close(progressCh)

	storage, err := s.storageResolver.Resolve(ctx)
	if err != nil {
		return fmt.Errorf("resolving storage: %w", err)
	}

	process, err := s.processRepo.GetByID(ctx, processID)
	if err != nil {
		return err
	}

	if err := process.Resume(); err != nil {
		return err
	}
	if err := s.processRepo.Update(ctx, process); err != nil {
		return fmt.Errorf("updating process: %w", err)
	}

	uploads, err := s.uploadRepo.ListByProcessID(ctx, processID)
	if err != nil {
		return err
	}

	uploadCtx, cancel := context.WithCancel(ctx)
	s.registerCancel(processID, cancel)
	defer s.unregisterCancel(processID)

	sem := make(chan struct{}, s.maxWorkers)
	var wg sync.WaitGroup

	for i := range uploads {
		if uploads[i].Status != valueobject.StatusPaused && uploads[i].Status != valueobject.StatusPending {
			continue
		}

		wg.Add(1)
		sem <- struct{}{}
		go func(u *entity.Upload) {
			defer wg.Done()
			defer func() { <-sem }()
			if err := s.executeUpload(uploadCtx, storage, u, progressCh); err != nil {
				s.logger.Error("executing upload", "upload_id", u.ID, "error", err)
			}
		}(&uploads[i])
	}
	wg.Wait()

	updatedUploads, err := s.uploadRepo.ListByProcessID(ctx, processID)
	if err != nil {
		return fmt.Errorf("listing uploads: %w", err)
	}
	newStatus := entity.DeriveProcessStatus(updatedUploads)
	if err := process.TransitionTo(newStatus); err != nil {
		return fmt.Errorf("transitioning process: %w", err)
	}
	if err := s.processRepo.Update(ctx, process); err != nil {
		return fmt.Errorf("updating process: %w", err)
	}

	return nil
}

func (s *UploadService) CancelProcess(ctx context.Context, processID string) error {
	storage, err := s.storageResolver.Resolve(ctx)
	if err != nil {
		return fmt.Errorf("resolving storage: %w", err)
	}

	process, err := s.processRepo.GetByID(ctx, processID)
	if err != nil {
		return err
	}

	if err := process.Cancel(); err != nil {
		return err
	}

	// Cancel running goroutines
	s.mu.Lock()
	if cancel, ok := s.cancelFuncs[processID]; ok {
		cancel()
	}
	s.mu.Unlock()

	uploads, err := s.uploadRepo.ListByProcessID(ctx, processID)
	if err != nil {
		return err
	}

	for _, u := range uploads {
		if u.Status.IsTerminal() {
			continue
		}

		// Abort multipart upload on storage if active
		if u.MultipartUploadID != "" {
			if err := storage.AbortMultipartUpload(ctx, u.StorageKey, u.MultipartUploadID); err != nil {
				s.logger.Error("aborting multipart upload", "upload_id", u.ID, "error", err)
			}
		}

		if err := u.TransitionTo(valueobject.StatusCancelled); err != nil {
			return fmt.Errorf("transitioning upload to cancelled: %w", err)
		}
		u.ClearMultipartState()
		if err := s.uploadRepo.Update(ctx, u); err != nil {
			return fmt.Errorf("updating upload: %w", err)
		}
	}

	if err := s.processRepo.Update(ctx, process); err != nil {
		return fmt.Errorf("updating process: %w", err)
	}
	return nil
}

func (s *UploadService) GetProcess(ctx context.Context, processID string) (driving.ProcessWithUploads, error) {
	process, err := s.processRepo.GetByID(ctx, processID)
	if err != nil {
		return driving.ProcessWithUploads{}, err
	}

	uploads, err := s.uploadRepo.ListByProcessID(ctx, processID)
	if err != nil {
		return driving.ProcessWithUploads{}, err
	}

	return driving.ProcessWithUploads{
		Process: process,
		Uploads: uploads,
	}, nil
}

func (s *UploadService) ListProcesses(ctx context.Context, cursor string, limit int) ([]entity.Process, string, error) {
	return s.processRepo.List(ctx, cursor, limit)
}

func (s *UploadService) executeUpload(ctx context.Context, storage driven.FileStorage, upload *entity.Upload, progressCh chan<- driving.UploadProgress) error {
	if err := upload.TransitionTo(valueobject.StatusInProgress); err != nil {
		return fmt.Errorf("transitioning upload to in-progress: %w", err)
	}
	if err := s.uploadRepo.Update(ctx, *upload); err != nil {
		return fmt.Errorf("updating upload: %w", err)
	}
	s.sendProgress(progressCh, *upload)

	// Init multipart if not already (resume case)
	if upload.MultipartUploadID == "" {
		uploadID, err := storage.InitMultipartUpload(ctx, upload.StorageKey)
		if err != nil {
			s.failUpload(ctx, upload, err)
			s.sendProgress(progressCh, *upload)
			return err
		}
		upload.SetMultipartUploadID(uploadID)
		if err := s.uploadRepo.Update(ctx, *upload); err != nil {
			return fmt.Errorf("updating upload: %w", err)
		}
	}

	f, err := os.Open(filepath.Clean(upload.FilePath))
	if err != nil {
		s.failUpload(ctx, upload, err)
		s.sendProgress(progressCh, *upload)
		return err
	}
	defer f.Close()

	totalParts := int32((upload.FileSize + s.partSize - 1) / s.partSize) // #nosec G115 -- max 10,000 parts (S3 limit)
	if err := s.uploadParts(ctx, storage, upload, f, totalParts, progressCh); err != nil {
		return err
	}

	// Complete multipart
	if err := storage.CompleteMultipartUpload(ctx, upload.StorageKey, upload.MultipartUploadID, upload.SortedCompletedParts()); err != nil {
		s.failUpload(ctx, upload, err)
		s.sendProgress(progressCh, *upload)
		return err
	}

	// Verify size
	remoteSize, err := storage.HeadObject(ctx, upload.StorageKey)
	if err != nil {
		s.logger.Warn("could not verify upload size", "upload_id", upload.ID, "error", err)
	} else if remoteSize != upload.FileSize {
		s.failUpload(ctx, upload, domain.ErrSizeMismatch)
		s.sendProgress(progressCh, *upload)
		return domain.ErrSizeMismatch
	}

	if err := upload.TransitionTo(valueobject.StatusCompleted); err != nil {
		return fmt.Errorf("transitioning upload to completed: %w", err)
	}
	if err := s.uploadRepo.Update(ctx, *upload); err != nil {
		return fmt.Errorf("updating upload: %w", err)
	}
	s.sendProgress(progressCh, *upload)

	return nil
}

func (s *UploadService) uploadParts(ctx context.Context, storage driven.FileStorage, upload *entity.Upload, f *os.File, totalParts int32, progressCh chan<- driving.UploadProgress) error {
	pendingParts := upload.PendingPartNumbers(totalParts)
	if len(pendingParts) == 0 {
		return nil
	}

	partCtx, partCancel := context.WithCancel(ctx)
	defer partCancel()

	resultCh := make(chan partResult, len(pendingParts))
	sem := make(chan struct{}, s.partsParallel)

	// Launch worker goroutines
	var wg sync.WaitGroup
	for _, partNum := range pendingParts {
		wg.Add(1)
		go func(pn int32) {
			defer wg.Done()

			select {
			case sem <- struct{}{}:
				defer func() { <-sem }()
			case <-partCtx.Done():
				resultCh <- partResult{err: partCtx.Err()}
				return
			}

			offset := int64(pn-1) * s.partSize
			size := s.partSize
			if offset+size > upload.FileSize {
				size = upload.FileSize - offset
			}

			partData := make([]byte, size)
			if _, err := f.ReadAt(partData, offset); err != nil && err != io.EOF {
				resultCh <- partResult{err: fmt.Errorf("reading part %d: %w", pn, err)}
				return
			}

			partHash := sha256.Sum256(partData)
			partSHA256 := hex.EncodeToString(partHash[:])

			etag, err := storage.UploadPart(partCtx, upload.StorageKey, upload.MultipartUploadID, pn, bytes.NewReader(partData), partSHA256)
			if err != nil {
				resultCh <- partResult{err: fmt.Errorf("uploading part %d: %w", pn, err)}
				return
			}

			resultCh <- partResult{
				part: valueobject.CompletedPart{
					PartNumber: pn,
					ETag:       etag,
					Size:       size,
				},
			}
		}(partNum)
	}

	// Close resultCh once all workers finish
	go func() {
		wg.Wait()
		close(resultCh)
	}()

	// Single collector: only this goroutine touches upload state
	var firstErr error
	for result := range resultCh {
		if result.err != nil {
			if firstErr == nil {
				firstErr = result.err
				partCancel()
			}
			continue
		}

		upload.AddCompletedPart(result.part)
		if err := s.uploadRepo.Update(ctx, *upload); err != nil {
			if firstErr == nil {
				firstErr = fmt.Errorf("updating upload: %w", err)
				partCancel()
			}
			continue
		}
		s.sendProgress(progressCh, *upload)
	}

	if firstErr != nil {
		if ctx.Err() != nil {
			// Parent context cancelled (pause/cancel)
			if err := upload.TransitionTo(valueobject.StatusPaused); err != nil {
				return fmt.Errorf("transitioning upload to paused: %w", err)
			}
			if err := s.uploadRepo.Update(ctx, *upload); err != nil {
				return fmt.Errorf("updating paused upload: %w", err)
			}
			s.sendProgress(progressCh, *upload)
			return ctx.Err()
		}
		s.failUpload(ctx, upload, firstErr)
		s.sendProgress(progressCh, *upload)
		return firstErr
	}

	return nil
}

func (s *UploadService) failUpload(ctx context.Context, upload *entity.Upload, cause error) {
	if err := upload.TransitionTo(valueobject.StatusFailed); err != nil {
		s.logger.Error("transitioning upload to failed", "upload_id", upload.ID, "error", err)
	}
	upload.SetError(cause.Error())
	if err := s.uploadRepo.Update(ctx, *upload); err != nil {
		s.logger.Error("updating failed upload", "upload_id", upload.ID, "error", err)
	}
}

func (s *UploadService) sendProgress(ch chan<- driving.UploadProgress, upload entity.Upload) {
	ch <- driving.UploadProgress{
		ProcessID:     upload.ProcessID,
		UploadID:      upload.ID,
		FilePath:      upload.FilePath,
		FileSize:      upload.FileSize,
		BytesUploaded: upload.BytesUploaded,
		Status:        upload.Status.String(),
		ErrorMessage:  upload.ErrorMessage,
	}
}

func (s *UploadService) registerCancel(processID string, cancel context.CancelFunc) {
	s.mu.Lock()
	s.cancelFuncs[processID] = cancel
	s.mu.Unlock()
}

func (s *UploadService) unregisterCancel(processID string) {
	s.mu.Lock()
	delete(s.cancelFuncs, processID)
	s.mu.Unlock()
}

func computeSHA256(path string) (string, error) {
	f, err := os.Open(filepath.Clean(path))
	if err != nil {
		return "", err
	}
	defer f.Close()

	h := sha256.New()
	if _, err := io.Copy(h, f); err != nil {
		return "", err
	}

	return hex.EncodeToString(h.Sum(nil)), nil
}
