package service_test

import (
	"context"
	"fmt"
	"io"
	"log/slog"
	"os"
	"path/filepath"
	"sync"
	"sync/atomic"
	"testing"

	"github.com/carlosealves2/FileGuardian/internal/app/service"
	"github.com/carlosealves2/FileGuardian/internal/domain/entity"
	"github.com/carlosealves2/FileGuardian/internal/domain/valueobject"
	"github.com/carlosealves2/FileGuardian/internal/ports/driven"
	"github.com/carlosealves2/FileGuardian/internal/ports/driven/mock"
	"github.com/carlosealves2/FileGuardian/internal/ports/driving"
)

func newMockStorageResolver(storage driven.FileStorage) *mock.StorageResolver {
	return &mock.StorageResolver{
		ResolveFn: func(ctx context.Context) (driven.FileStorage, error) {
			return storage, nil
		},
	}
}

func TestUploadService_UploadFile(t *testing.T) {
	// Create a temp file
	tmpDir := t.TempDir()
	filePath := filepath.Join(tmpDir, "test.txt")
	os.WriteFile(filePath, []byte("hello world test data"), 0o644)

	var createdProcess entity.Process
	var createdUpload entity.Upload
	var updatedUploads []entity.Upload

	processRepo := &mock.ProcessRepository{
		CreateFn: func(ctx context.Context, p entity.Process) error {
			createdProcess = p
			return nil
		},
		GetByIDFn: func(ctx context.Context, id string) (entity.Process, error) {
			return createdProcess, nil
		},
		UpdateFn: func(ctx context.Context, p entity.Process) error {
			createdProcess = p
			return nil
		},
	}

	uploadRepo := &mock.UploadRepository{
		CreateFn: func(ctx context.Context, u entity.Upload) error {
			createdUpload = u
			return nil
		},
		GetByIDFn: func(ctx context.Context, id string) (entity.Upload, error) {
			return createdUpload, nil
		},
		UpdateFn: func(ctx context.Context, u entity.Upload) error {
			createdUpload = u
			return nil
		},
		ListByProcessIDFn: func(ctx context.Context, processID string) ([]entity.Upload, error) {
			if len(updatedUploads) > 0 {
				return updatedUploads, nil
			}
			return []entity.Upload{createdUpload}, nil
		},
	}

	storage := &mock.FileStorage{
		ProviderFn: func() string { return "S3" },
		InitMultipartUploadFn: func(ctx context.Context, key string) (string, error) {
			return "mp-123", nil
		},
		UploadPartFn: func(ctx context.Context, key, uploadID string, partNumber int32, body io.ReadSeeker, contentSHA256 string) (string, error) {
			return "etag-1", nil
		},
		CompleteMultipartUploadFn: func(ctx context.Context, key, uploadID string, parts []valueobject.CompletedPart) error {
			// Update mock to reflect completed state
			createdUpload.TransitionTo(valueobject.StatusCompleted)
			updatedUploads = []entity.Upload{createdUpload}
			return nil
		},
		HeadObjectFn: func(ctx context.Context, key string) (int64, error) {
			return 21, nil // len("hello world test data")
		},
	}

	logger := slog.New(slog.NewTextHandler(io.Discard, nil))
	resolver := newMockStorageResolver(storage)
	svc := service.NewUploadService(processRepo, uploadRepo, resolver, logger, 5*1024*1024, 5, 3)

	progressCh := make(chan driving.UploadProgress, 100)
	err := svc.UploadFile(context.Background(), filePath, progressCh)
	if err != nil {
		t.Fatalf("upload file: %v", err)
	}

	// Collect progress events
	var events []driving.UploadProgress
	for p := range progressCh {
		events = append(events, p)
	}

	if len(events) == 0 {
		t.Fatal("expected progress events")
	}

	lastEvent := events[len(events)-1]
	if lastEvent.Status != "COMPLETED" {
		t.Errorf("expected last status COMPLETED, got %s", lastEvent.Status)
	}

	if createdUpload.Checksum == "" {
		t.Error("expected non-empty checksum")
	}
}

func TestUploadService_UploadFile_InvalidPath(t *testing.T) {
	processRepo := &mock.ProcessRepository{}
	uploadRepo := &mock.UploadRepository{}
	storage := &mock.FileStorage{ProviderFn: func() string { return "S3" }}
	resolver := newMockStorageResolver(storage)
	logger := slog.New(slog.NewTextHandler(io.Discard, nil))

	svc := service.NewUploadService(processRepo, uploadRepo, resolver, logger, 5*1024*1024, 5, 3)

	progressCh := make(chan driving.UploadProgress, 100)
	err := svc.UploadFile(context.Background(), "/nonexistent/file.txt", progressCh)
	if err == nil {
		t.Fatal("expected error for nonexistent file")
	}
}

func TestUploadService_PauseAndResume(t *testing.T) {
	var storedProcess entity.Process
	var storedUploads []entity.Upload

	processRepo := &mock.ProcessRepository{
		CreateFn: func(ctx context.Context, p entity.Process) error {
			storedProcess = p
			return nil
		},
		GetByIDFn: func(ctx context.Context, id string) (entity.Process, error) {
			return storedProcess, nil
		},
		UpdateFn: func(ctx context.Context, p entity.Process) error {
			storedProcess = p
			return nil
		},
	}

	uploadRepo := &mock.UploadRepository{
		CreateFn: func(ctx context.Context, u entity.Upload) error {
			storedUploads = append(storedUploads, u)
			return nil
		},
		UpdateFn: func(ctx context.Context, u entity.Upload) error {
			for i, su := range storedUploads {
				if su.ID == u.ID {
					storedUploads[i] = u
					break
				}
			}
			return nil
		},
		ListByProcessIDFn: func(ctx context.Context, processID string) ([]entity.Upload, error) {
			return storedUploads, nil
		},
	}

	storage := &mock.FileStorage{
		ProviderFn: func() string { return "S3" },
	}
	resolver := newMockStorageResolver(storage)
	logger := slog.New(slog.NewTextHandler(io.Discard, nil))

	svc := service.NewUploadService(processRepo, uploadRepo, resolver, logger, 5*1024*1024, 5, 3)

	// Setup: create a process in IN_PROGRESS state with an IN_PROGRESS upload
	storedProcess = entity.NewProcess("p1", valueobject.ProcessTypeFile, "S3", "/tmp/file.txt")
	storedProcess.TransitionTo(valueobject.StatusInProgress)

	upload := entity.NewUpload("u1", "p1", "/tmp/file.txt", "file.txt", 1024, "hash")
	upload.TransitionTo(valueobject.StatusInProgress)
	upload.SetMultipartUploadID("mp-123")
	storedUploads = []entity.Upload{upload}

	// Pause
	err := svc.PauseProcess(context.Background(), "p1")
	if err != nil {
		t.Fatalf("pause: %v", err)
	}

	if storedProcess.Status != valueobject.StatusPaused {
		t.Errorf("expected process PAUSED, got %s", storedProcess.Status)
	}
	if storedUploads[0].Status != valueobject.StatusPaused {
		t.Errorf("expected upload PAUSED, got %s", storedUploads[0].Status)
	}
}

func TestUploadService_CancelProcess(t *testing.T) {
	var storedProcess entity.Process
	var storedUploads []entity.Upload

	processRepo := &mock.ProcessRepository{
		GetByIDFn: func(ctx context.Context, id string) (entity.Process, error) {
			return storedProcess, nil
		},
		UpdateFn: func(ctx context.Context, p entity.Process) error {
			storedProcess = p
			return nil
		},
	}

	uploadRepo := &mock.UploadRepository{
		UpdateFn: func(ctx context.Context, u entity.Upload) error {
			for i, su := range storedUploads {
				if su.ID == u.ID {
					storedUploads[i] = u
					break
				}
			}
			return nil
		},
		ListByProcessIDFn: func(ctx context.Context, processID string) ([]entity.Upload, error) {
			return storedUploads, nil
		},
	}

	abortCalled := false
	storage := &mock.FileStorage{
		ProviderFn: func() string { return "S3" },
		AbortMultipartUploadFn: func(ctx context.Context, key, uploadID string) error {
			abortCalled = true
			return nil
		},
	}
	resolver := newMockStorageResolver(storage)
	logger := slog.New(slog.NewTextHandler(io.Discard, nil))

	svc := service.NewUploadService(processRepo, uploadRepo, resolver, logger, 5*1024*1024, 5, 3)

	storedProcess = entity.NewProcess("p1", valueobject.ProcessTypeFile, "S3", "/tmp/file.txt")
	storedProcess.TransitionTo(valueobject.StatusInProgress)

	upload := entity.NewUpload("u1", "p1", "/tmp/file.txt", "file.txt", 1024, "hash")
	upload.TransitionTo(valueobject.StatusInProgress)
	upload.SetMultipartUploadID("mp-123")
	storedUploads = []entity.Upload{upload}

	err := svc.CancelProcess(context.Background(), "p1")
	if err != nil {
		t.Fatalf("cancel: %v", err)
	}

	if storedProcess.Status != valueobject.StatusCancelled {
		t.Errorf("expected process CANCELLED, got %s", storedProcess.Status)
	}
	if storedUploads[0].Status != valueobject.StatusCancelled {
		t.Errorf("expected upload CANCELLED, got %s", storedUploads[0].Status)
	}
	if !abortCalled {
		t.Error("expected AbortMultipartUpload to be called")
	}
	if storedUploads[0].MultipartUploadID != "" {
		t.Error("expected multipart state cleared")
	}
}

func TestUploadService_GetProcess(t *testing.T) {
	process := entity.NewProcess("p1", valueobject.ProcessTypeFile, "S3", "/tmp/file.txt")
	uploads := []entity.Upload{
		entity.NewUpload("u1", "p1", "/tmp/file.txt", "file.txt", 1024, "hash"),
	}

	processRepo := &mock.ProcessRepository{
		GetByIDFn: func(ctx context.Context, id string) (entity.Process, error) {
			return process, nil
		},
	}
	uploadRepo := &mock.UploadRepository{
		ListByProcessIDFn: func(ctx context.Context, processID string) ([]entity.Upload, error) {
			return uploads, nil
		},
	}
	storage := &mock.FileStorage{ProviderFn: func() string { return "S3" }}
	resolver := newMockStorageResolver(storage)
	logger := slog.New(slog.NewTextHandler(io.Discard, nil))

	svc := service.NewUploadService(processRepo, uploadRepo, resolver, logger, 5*1024*1024, 5, 3)

	result, err := svc.GetProcess(context.Background(), "p1")
	if err != nil {
		t.Fatalf("get process: %v", err)
	}
	if result.Process.ID != "p1" {
		t.Errorf("expected p1, got %s", result.Process.ID)
	}
	if len(result.Uploads) != 1 {
		t.Errorf("expected 1 upload, got %d", len(result.Uploads))
	}
}

func TestUploadService_ListProcesses(t *testing.T) {
	processes := []entity.Process{
		entity.NewProcess("p1", valueobject.ProcessTypeFile, "S3", "/tmp/file.txt"),
	}

	processRepo := &mock.ProcessRepository{
		ListFn: func(ctx context.Context, cursor string, limit int) ([]entity.Process, string, error) {
			return processes, "", nil
		},
	}
	uploadRepo := &mock.UploadRepository{}
	storage := &mock.FileStorage{ProviderFn: func() string { return "S3" }}
	resolver := newMockStorageResolver(storage)
	logger := slog.New(slog.NewTextHandler(io.Discard, nil))

	svc := service.NewUploadService(processRepo, uploadRepo, resolver, logger, 5*1024*1024, 5, 3)

	result, cursor, err := svc.ListProcesses(context.Background(), "", 20)
	if err != nil {
		t.Fatalf("list: %v", err)
	}
	if len(result) != 1 {
		t.Errorf("expected 1, got %d", len(result))
	}
	if cursor != "" {
		t.Errorf("expected empty cursor, got %s", cursor)
	}
}

func TestUploadService_UploadFile_ConcurrentParts(t *testing.T) {
	// Create a 15MB temp file (3 parts of 5MB each)
	tmpDir := t.TempDir()
	filePath := filepath.Join(tmpDir, "bigfile.bin")
	data := make([]byte, 15*1024*1024)
	for i := range data {
		data[i] = byte(i % 256)
	}
	os.WriteFile(filePath, data, 0o644)

	var createdProcess entity.Process
	var createdUpload entity.Upload
	var updatedUploads []entity.Upload
	var uploadMu sync.Mutex

	processRepo := &mock.ProcessRepository{
		CreateFn: func(ctx context.Context, p entity.Process) error {
			createdProcess = p
			return nil
		},
		GetByIDFn: func(ctx context.Context, id string) (entity.Process, error) {
			return createdProcess, nil
		},
		UpdateFn: func(ctx context.Context, p entity.Process) error {
			createdProcess = p
			return nil
		},
	}

	uploadRepo := &mock.UploadRepository{
		CreateFn: func(ctx context.Context, u entity.Upload) error {
			uploadMu.Lock()
			createdUpload = u
			uploadMu.Unlock()
			return nil
		},
		GetByIDFn: func(ctx context.Context, id string) (entity.Upload, error) {
			uploadMu.Lock()
			defer uploadMu.Unlock()
			return createdUpload, nil
		},
		UpdateFn: func(ctx context.Context, u entity.Upload) error {
			uploadMu.Lock()
			createdUpload = u
			uploadMu.Unlock()
			return nil
		},
		ListByProcessIDFn: func(ctx context.Context, processID string) ([]entity.Upload, error) {
			uploadMu.Lock()
			defer uploadMu.Unlock()
			if len(updatedUploads) > 0 {
				return updatedUploads, nil
			}
			return []entity.Upload{createdUpload}, nil
		},
	}

	var uploadPartCalls atomic.Int32
	storage := &mock.FileStorage{
		ProviderFn: func() string { return "S3" },
		InitMultipartUploadFn: func(ctx context.Context, key string) (string, error) {
			return "mp-concurrent", nil
		},
		UploadPartFn: func(ctx context.Context, key, uploadID string, partNumber int32, body io.ReadSeeker, contentSHA256 string) (string, error) {
			uploadPartCalls.Add(1)
			return fmt.Sprintf("etag-%d", partNumber), nil
		},
		CompleteMultipartUploadFn: func(ctx context.Context, key, uploadID string, parts []valueobject.CompletedPart) error {
			uploadMu.Lock()
			createdUpload.TransitionTo(valueobject.StatusCompleted)
			updatedUploads = []entity.Upload{createdUpload}
			uploadMu.Unlock()
			return nil
		},
		HeadObjectFn: func(ctx context.Context, key string) (int64, error) {
			return 15 * 1024 * 1024, nil
		},
	}

	logger := slog.New(slog.NewTextHandler(io.Discard, nil))
	resolver := newMockStorageResolver(storage)
	svc := service.NewUploadService(processRepo, uploadRepo, resolver, logger, 5*1024*1024, 5, 3)

	progressCh := make(chan driving.UploadProgress, 100)
	err := svc.UploadFile(context.Background(), filePath, progressCh)
	if err != nil {
		t.Fatalf("upload file: %v", err)
	}

	// Collect progress events
	var events []driving.UploadProgress
	for p := range progressCh {
		events = append(events, p)
	}

	// Verify all 3 parts were uploaded
	if uploadPartCalls.Load() != 3 {
		t.Errorf("expected 3 UploadPart calls, got %d", uploadPartCalls.Load())
	}

	if len(events) == 0 {
		t.Fatal("expected progress events")
	}

	lastEvent := events[len(events)-1]
	if lastEvent.Status != "COMPLETED" {
		t.Errorf("expected last status COMPLETED, got %s", lastEvent.Status)
	}
	if lastEvent.BytesUploaded != 15*1024*1024 {
		t.Errorf("expected %d bytes uploaded, got %d", 15*1024*1024, lastEvent.BytesUploaded)
	}
}
