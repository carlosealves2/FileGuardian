package resolver

import (
	"context"
	"fmt"

	"github.com/carlosealves2/FileGuardian/internal/domain"
	"github.com/carlosealves2/FileGuardian/internal/ports/driven"
)

type StorageResolver struct {
	configRepo driven.ConfigRepository
	factory    driven.StorageFactory
}

func NewStorageResolver(configRepo driven.ConfigRepository, factory driven.StorageFactory) *StorageResolver {
	return &StorageResolver{configRepo: configRepo, factory: factory}
}

func (r *StorageResolver) Resolve(ctx context.Context) (driven.FileStorage, error) {
	provider, err := r.configRepo.GetActiveProvider(ctx)
	if err != nil {
		return nil, fmt.Errorf("reading active provider: %w", err)
	}
	if provider == "" {
		return nil, domain.ErrNoActiveProvider
	}

	storage, err := r.factory.Create(ctx, provider)
	if err != nil {
		return nil, fmt.Errorf("creating storage for provider %s: %w", provider, err)
	}
	return storage, nil
}
