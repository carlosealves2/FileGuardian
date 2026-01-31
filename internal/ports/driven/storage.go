package driven

import (
	"context"
	"io"

	"github.com/carlosealves2/FileGuardian/internal/domain/valueobject"
)

// FileStorage is the interface that all storage providers must implement.
// Each provider (S3, Azure, Mega, etc.) is an adapter that implements this interface.
// The design uses multipart upload as a generic concept - each provider maps
// to its equivalent (S3 Multipart, Azure Block Blob, etc.).
type FileStorage interface {
	// Provider returns the provider name (e.g., "S3", "AZURE", "MEGA").
	Provider() string

	// InitMultipartUpload initializes a new multipart upload and returns the upload ID.
	InitMultipartUpload(ctx context.Context, key string) (uploadID string, err error)

	// UploadPart uploads a single part of a multipart upload.
	// contentSHA256 is the hex-encoded SHA256 of the part body for integrity verification.
	UploadPart(ctx context.Context, key, uploadID string, partNumber int32, body io.ReadSeeker, contentSHA256 string) (etag string, err error)

	// CompleteMultipartUpload finalizes a multipart upload with the given completed parts.
	CompleteMultipartUpload(ctx context.Context, key, uploadID string, parts []valueobject.CompletedPart) error

	// AbortMultipartUpload cancels a multipart upload and cleans up uploaded parts.
	AbortMultipartUpload(ctx context.Context, key, uploadID string) error

	// HeadObject returns the size of an object in storage.
	HeadObject(ctx context.Context, key string) (size int64, err error)
}

// StorageFactory creates the appropriate FileStorage adapter based on provider name.
type StorageFactory interface {
	Create(ctx context.Context, provider string) (FileStorage, error)
}
