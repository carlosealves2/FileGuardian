package mock

import (
	"context"

	"github.com/carlosealves2/FileGuardian/internal/ports/driven"
)

type StorageResolver struct {
	ResolveFn func(ctx context.Context) (driven.FileStorage, error)
}

func (m *StorageResolver) Resolve(ctx context.Context) (driven.FileStorage, error) {
	return m.ResolveFn(ctx)
}
