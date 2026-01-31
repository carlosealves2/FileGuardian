package sqlite_test

import (
	"context"
	"testing"

	"github.com/carlosealves2/FileGuardian/internal/adapters/driven/repository/sqlite"
	"github.com/carlosealves2/FileGuardian/internal/domain"
	"github.com/carlosealves2/FileGuardian/internal/domain/entity"
	"github.com/carlosealves2/FileGuardian/internal/domain/valueobject"
)

func TestUploadRepository_CreateAndGetByID(t *testing.T) {
	db := setupTestDB(t)
	processRepo := sqlite.NewProcessRepository(db)
	uploadRepo := sqlite.NewUploadRepository(db)
	ctx := context.Background()

	p := entity.NewProcess("p1", valueobject.ProcessTypeFile, "S3", "/tmp/file.txt")
	processRepo.Create(ctx, p)

	u := entity.NewUpload("u1", "p1", "/tmp/file.txt", "uploads/file.txt", 1024, "sha256hash")

	if err := uploadRepo.Create(ctx, u); err != nil {
		t.Fatalf("create: %v", err)
	}

	got, err := uploadRepo.GetByID(ctx, "u1")
	if err != nil {
		t.Fatalf("get by id: %v", err)
	}

	if got.ID != "u1" {
		t.Errorf("expected ID u1, got %s", got.ID)
	}
	if got.ProcessID != "p1" {
		t.Errorf("expected process_id p1, got %s", got.ProcessID)
	}
	if got.FileSize != 1024 {
		t.Errorf("expected file_size 1024, got %d", got.FileSize)
	}
	if got.Checksum != "sha256hash" {
		t.Errorf("expected checksum sha256hash, got %s", got.Checksum)
	}
}

func TestUploadRepository_GetByID_NotFound(t *testing.T) {
	db := setupTestDB(t)
	repo := sqlite.NewUploadRepository(db)

	_, err := repo.GetByID(context.Background(), "nonexistent")
	if err != domain.ErrNotFound {
		t.Fatalf("expected ErrNotFound, got: %v", err)
	}
}

func TestUploadRepository_Update(t *testing.T) {
	db := setupTestDB(t)
	processRepo := sqlite.NewProcessRepository(db)
	uploadRepo := sqlite.NewUploadRepository(db)
	ctx := context.Background()

	p := entity.NewProcess("p1", valueobject.ProcessTypeFile, "S3", "/tmp/file.txt")
	processRepo.Create(ctx, p)

	u := entity.NewUpload("u1", "p1", "/tmp/file.txt", "uploads/file.txt", 1024, "sha256hash")
	uploadRepo.Create(ctx, u)

	u.TransitionTo(valueobject.StatusInProgress)
	u.SetMultipartUploadID("mp-123")
	u.AddCompletedPart(valueobject.CompletedPart{PartNumber: 1, ETag: "etag1", Size: 512})

	if err := uploadRepo.Update(ctx, u); err != nil {
		t.Fatalf("update: %v", err)
	}

	got, _ := uploadRepo.GetByID(ctx, "u1")
	if got.Status != valueobject.StatusInProgress {
		t.Errorf("expected IN_PROGRESS, got %s", got.Status)
	}
	if got.MultipartUploadID != "mp-123" {
		t.Errorf("expected mp-123, got %s", got.MultipartUploadID)
	}
	if len(got.CompletedParts) != 1 {
		t.Fatalf("expected 1 completed part, got %d", len(got.CompletedParts))
	}
	if got.CompletedParts[0].ETag != "etag1" {
		t.Errorf("expected etag1, got %s", got.CompletedParts[0].ETag)
	}
	if got.BytesUploaded != 512 {
		t.Errorf("expected 512 bytes uploaded, got %d", got.BytesUploaded)
	}
}

func TestUploadRepository_ListByProcessID(t *testing.T) {
	db := setupTestDB(t)
	processRepo := sqlite.NewProcessRepository(db)
	uploadRepo := sqlite.NewUploadRepository(db)
	ctx := context.Background()

	p := entity.NewProcess("p1", valueobject.ProcessTypeFolder, "S3", "/tmp/folder")
	processRepo.Create(ctx, p)

	for i := range 3 {
		u := entity.NewUpload(
			"u"+string(rune('1'+i)),
			"p1",
			"/tmp/folder/file"+string(rune('1'+i)),
			"uploads/file"+string(rune('1'+i)),
			1024,
			"hash",
		)
		uploadRepo.Create(ctx, u)
	}

	uploads, err := uploadRepo.ListByProcessID(ctx, "p1")
	if err != nil {
		t.Fatalf("list: %v", err)
	}
	if len(uploads) != 3 {
		t.Fatalf("expected 3, got %d", len(uploads))
	}
}

func TestUploadRepository_ListByProcessID_Empty(t *testing.T) {
	db := setupTestDB(t)
	uploadRepo := sqlite.NewUploadRepository(db)

	uploads, err := uploadRepo.ListByProcessID(context.Background(), "nonexistent")
	if err != nil {
		t.Fatalf("list: %v", err)
	}
	if len(uploads) != 0 {
		t.Fatalf("expected 0, got %d", len(uploads))
	}
}
