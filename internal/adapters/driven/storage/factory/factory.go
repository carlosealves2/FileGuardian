package factory

import (
	"context"
	"fmt"

	s3storage "github.com/carlosealves2/FileGuardian/internal/adapters/driven/storage/s3"
	"github.com/carlosealves2/FileGuardian/internal/domain"
	"github.com/carlosealves2/FileGuardian/internal/ports/driven"
)

type StorageFactory struct {
	configRepo driven.ConfigRepository
	secrets    driven.SecretStore
}

func NewStorageFactory(configRepo driven.ConfigRepository, secrets driven.SecretStore) *StorageFactory {
	return &StorageFactory{configRepo: configRepo, secrets: secrets}
}

func (f *StorageFactory) Create(ctx context.Context, provider string) (driven.FileStorage, error) {
	switch provider {
	case "S3":
		return f.createS3(ctx, provider)
	default:
		return nil, fmt.Errorf("%w: %s", domain.ErrUnsupportedProvider, provider)
	}
}

func (f *StorageFactory) createS3(ctx context.Context, provider string) (driven.FileStorage, error) {
	dbValues, err := f.configRepo.GetAll(ctx, provider)
	if err != nil {
		return nil, fmt.Errorf("reading config for S3: %w", err)
	}

	accessKeyID, _ := f.secrets.Get(provider, "access_key_id")
	secretAccessKey, _ := f.secrets.Get(provider, "secret_access_key")

	cfg := s3storage.S3Config{
		Region:         dbValues["region"],
		Bucket:         dbValues["bucket"],
		AccessKeyID:    accessKeyID,
		SecretAccessKey: secretAccessKey,
		Endpoint:       dbValues["endpoint"],
	}

	storage, err := s3storage.NewStorage(ctx, cfg)
	if err != nil {
		return nil, fmt.Errorf("creating S3 storage: %w", err)
	}
	return storage, nil
}
