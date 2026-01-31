package driven

import (
	"context"

	"github.com/carlosealves2/FileGuardian/internal/domain/entity"
)

// ProcessRepository defines the contract for process persistence.
type ProcessRepository interface {
	Create(ctx context.Context, process entity.Process) error
	GetByID(ctx context.Context, id string) (entity.Process, error)
	Update(ctx context.Context, process entity.Process) error
	List(ctx context.Context, cursor string, limit int) ([]entity.Process, string, error)
}

// UploadRepository defines the contract for upload persistence.
type UploadRepository interface {
	Create(ctx context.Context, upload entity.Upload) error
	GetByID(ctx context.Context, id string) (entity.Upload, error)
	Update(ctx context.Context, upload entity.Upload) error
	ListByProcessID(ctx context.Context, processID string) ([]entity.Upload, error)
}
