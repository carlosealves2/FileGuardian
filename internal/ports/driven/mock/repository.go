package mock

import (
	"context"

	"github.com/carlosealves2/FileGuardian/internal/domain/entity"
)

type ProcessRepository struct {
	CreateFn  func(ctx context.Context, process entity.Process) error
	GetByIDFn func(ctx context.Context, id string) (entity.Process, error)
	UpdateFn  func(ctx context.Context, process entity.Process) error
	ListFn    func(ctx context.Context, cursor string, limit int) ([]entity.Process, string, error)
}

func (m *ProcessRepository) Create(ctx context.Context, process entity.Process) error {
	return m.CreateFn(ctx, process)
}
func (m *ProcessRepository) GetByID(ctx context.Context, id string) (entity.Process, error) {
	return m.GetByIDFn(ctx, id)
}
func (m *ProcessRepository) Update(ctx context.Context, process entity.Process) error {
	return m.UpdateFn(ctx, process)
}
func (m *ProcessRepository) List(ctx context.Context, cursor string, limit int) ([]entity.Process, string, error) {
	return m.ListFn(ctx, cursor, limit)
}

type UploadRepository struct {
	CreateFn          func(ctx context.Context, upload entity.Upload) error
	GetByIDFn         func(ctx context.Context, id string) (entity.Upload, error)
	UpdateFn          func(ctx context.Context, upload entity.Upload) error
	ListByProcessIDFn func(ctx context.Context, processID string) ([]entity.Upload, error)
}

func (m *UploadRepository) Create(ctx context.Context, upload entity.Upload) error {
	return m.CreateFn(ctx, upload)
}
func (m *UploadRepository) GetByID(ctx context.Context, id string) (entity.Upload, error) {
	return m.GetByIDFn(ctx, id)
}
func (m *UploadRepository) Update(ctx context.Context, upload entity.Upload) error {
	return m.UpdateFn(ctx, upload)
}
func (m *UploadRepository) ListByProcessID(ctx context.Context, processID string) ([]entity.Upload, error) {
	return m.ListByProcessIDFn(ctx, processID)
}
