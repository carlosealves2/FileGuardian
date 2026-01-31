package entity

import (
	"time"

	"github.com/carlosealves2/FileGuardian/internal/domain/valueobject"
)

type Upload struct {
	ID                string
	ProcessID         string
	FilePath          string
	StorageKey        string
	FileSize          int64
	BytesUploaded     int64
	Status            valueobject.Status
	ErrorMessage      string
	Checksum          string
	MultipartUploadID string
	CompletedParts    []valueobject.CompletedPart
	CreatedAt         time.Time
	UpdatedAt         time.Time
}

func NewUpload(id, processID, filePath, storageKey string, fileSize int64, checksum string) Upload {
	now := time.Now().UTC()
	return Upload{
		ID:             id,
		ProcessID:      processID,
		FilePath:       filePath,
		StorageKey:     storageKey,
		FileSize:       fileSize,
		BytesUploaded:  0,
		Status:         valueobject.StatusPending,
		Checksum:       checksum,
		CompletedParts: nil,
		CreatedAt:      now,
		UpdatedAt:      now,
	}
}

func (u *Upload) TransitionTo(status valueobject.Status) error {
	next, err := u.Status.TransitionTo(status)
	if err != nil {
		return err
	}
	u.Status = next
	u.UpdatedAt = time.Now().UTC()
	return nil
}

func (u *Upload) AddCompletedPart(part valueobject.CompletedPart) {
	u.CompletedParts = append(u.CompletedParts, part)
	u.BytesUploaded += part.Size
	u.UpdatedAt = time.Now().UTC()
}

func (u *Upload) NextPartNumber() int32 {
	return int32(len(u.CompletedParts) + 1) // #nosec G115 -- max 10,000 parts (S3 limit)
}

func (u *Upload) SetMultipartUploadID(uploadID string) {
	u.MultipartUploadID = uploadID
	u.UpdatedAt = time.Now().UTC()
}

func (u *Upload) SetError(msg string) {
	u.ErrorMessage = msg
	u.UpdatedAt = time.Now().UTC()
}

func (u *Upload) ClearMultipartState() {
	u.MultipartUploadID = ""
	u.CompletedParts = nil
	u.UpdatedAt = time.Now().UTC()
}
