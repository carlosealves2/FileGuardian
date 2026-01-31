package mock

import (
	"context"
	"io"

	"github.com/carlosealves2/FileGuardian/internal/domain/valueobject"
	"github.com/carlosealves2/FileGuardian/internal/ports/driven"
)

type FileStorage struct {
	ProviderFn                func() string
	InitMultipartUploadFn     func(ctx context.Context, key string) (string, error)
	UploadPartFn              func(ctx context.Context, key, uploadID string, partNumber int32, body io.ReadSeeker, contentSHA256 string) (string, error)
	CompleteMultipartUploadFn func(ctx context.Context, key, uploadID string, parts []valueobject.CompletedPart) error
	AbortMultipartUploadFn    func(ctx context.Context, key, uploadID string) error
	HeadObjectFn              func(ctx context.Context, key string) (int64, error)
}

func (m *FileStorage) Provider() string                { return m.ProviderFn() }
func (m *FileStorage) InitMultipartUpload(ctx context.Context, key string) (string, error) {
	return m.InitMultipartUploadFn(ctx, key)
}
func (m *FileStorage) UploadPart(ctx context.Context, key, uploadID string, partNumber int32, body io.ReadSeeker, contentSHA256 string) (string, error) {
	return m.UploadPartFn(ctx, key, uploadID, partNumber, body, contentSHA256)
}
func (m *FileStorage) CompleteMultipartUpload(ctx context.Context, key, uploadID string, parts []valueobject.CompletedPart) error {
	return m.CompleteMultipartUploadFn(ctx, key, uploadID, parts)
}
func (m *FileStorage) AbortMultipartUpload(ctx context.Context, key, uploadID string) error {
	return m.AbortMultipartUploadFn(ctx, key, uploadID)
}
func (m *FileStorage) HeadObject(ctx context.Context, key string) (int64, error) {
	return m.HeadObjectFn(ctx, key)
}

type StorageFactory struct {
	CreateFn func(ctx context.Context, provider string) (driven.FileStorage, error)
}

func (m *StorageFactory) Create(ctx context.Context, provider string) (driven.FileStorage, error) {
	return m.CreateFn(ctx, provider)
}
