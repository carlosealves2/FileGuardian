package driven

import "context"

// StorageResolver lazily resolves the active storage provider at runtime.
type StorageResolver interface {
	Resolve(ctx context.Context) (FileStorage, error)
}
