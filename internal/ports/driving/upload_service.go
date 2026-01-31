package driving

import (
	"context"

	"github.com/carlosealves2/FileGuardian/internal/domain/entity"
)

// UploadProgress represents a progress update for an upload operation.
type UploadProgress struct {
	ProcessID     string
	UploadID      string
	FilePath      string
	FileSize      int64
	BytesUploaded int64
	Status        string
	ErrorMessage  string
}

// ProcessWithUploads groups a process with its uploads.
type ProcessWithUploads struct {
	Process entity.Process
	Uploads []entity.Upload
}

// UploadService defines the contract for upload operations.
type UploadService interface {
	UploadFile(ctx context.Context, filePath string, progressCh chan<- UploadProgress) error
	UploadFolder(ctx context.Context, folderPath string, progressCh chan<- UploadProgress) error
	PauseProcess(ctx context.Context, processID string) error
	ResumeProcess(ctx context.Context, processID string, progressCh chan<- UploadProgress) error
	CancelProcess(ctx context.Context, processID string) error
	GetProcess(ctx context.Context, processID string) (ProcessWithUploads, error)
	ListProcesses(ctx context.Context, cursor string, limit int) ([]entity.Process, string, error)
}
