package entity_test

import (
	"testing"

	"github.com/carlosealves2/FileGuardian/internal/domain/entity"
	"github.com/carlosealves2/FileGuardian/internal/domain/valueobject"
)

func TestNewUpload(t *testing.T) {
	u := entity.NewUpload("u1", "p1", "/tmp/file.txt", "uploads/file.txt", 1024, "abc123")

	if u.ID != "u1" {
		t.Errorf("expected ID u1, got %s", u.ID)
	}
	if u.Status != valueobject.StatusPending {
		t.Errorf("expected PENDING, got %s", u.Status)
	}
	if u.BytesUploaded != 0 {
		t.Errorf("expected 0 bytes uploaded, got %d", u.BytesUploaded)
	}
	if u.Checksum != "abc123" {
		t.Errorf("expected checksum abc123, got %s", u.Checksum)
	}
}

func TestUpload_AddCompletedPart(t *testing.T) {
	u := entity.NewUpload("u1", "p1", "/tmp/file.txt", "uploads/file.txt", 10*1024*1024, "abc123")

	part := valueobject.CompletedPart{
		PartNumber: 1,
		ETag:       "etag1",
		Size:       5 * 1024 * 1024,
	}
	u.AddCompletedPart(part)

	if len(u.CompletedParts) != 1 {
		t.Fatalf("expected 1 part, got %d", len(u.CompletedParts))
	}
	if u.BytesUploaded != 5*1024*1024 {
		t.Errorf("expected %d bytes uploaded, got %d", 5*1024*1024, u.BytesUploaded)
	}
	if u.NextPartNumber() != 2 {
		t.Errorf("expected next part 2, got %d", u.NextPartNumber())
	}
}

func TestUpload_SetMultipartUploadID(t *testing.T) {
	u := entity.NewUpload("u1", "p1", "/tmp/file.txt", "uploads/file.txt", 1024, "abc123")
	u.SetMultipartUploadID("mp-123")

	if u.MultipartUploadID != "mp-123" {
		t.Errorf("expected mp-123, got %s", u.MultipartUploadID)
	}
}

func TestUpload_ClearMultipartState(t *testing.T) {
	u := entity.NewUpload("u1", "p1", "/tmp/file.txt", "uploads/file.txt", 1024, "abc123")
	u.SetMultipartUploadID("mp-123")
	u.AddCompletedPart(valueobject.CompletedPart{PartNumber: 1, ETag: "etag", Size: 512})

	u.ClearMultipartState()

	if u.MultipartUploadID != "" {
		t.Errorf("expected empty multipart upload ID, got %s", u.MultipartUploadID)
	}
	if u.CompletedParts != nil {
		t.Errorf("expected nil completed parts, got %v", u.CompletedParts)
	}
}

func TestUpload_StateTransitions(t *testing.T) {
	u := entity.NewUpload("u1", "p1", "/tmp/file.txt", "uploads/file.txt", 1024, "abc123")

	if err := u.TransitionTo(valueobject.StatusInProgress); err != nil {
		t.Fatalf("expected transition to IN_PROGRESS: %v", err)
	}

	if err := u.TransitionTo(valueobject.StatusPaused); err != nil {
		t.Fatalf("expected transition to PAUSED: %v", err)
	}

	if err := u.TransitionTo(valueobject.StatusInProgress); err != nil {
		t.Fatalf("expected transition back to IN_PROGRESS: %v", err)
	}

	if err := u.TransitionTo(valueobject.StatusCompleted); err != nil {
		t.Fatalf("expected transition to COMPLETED: %v", err)
	}

	// Cannot transition from COMPLETED
	if err := u.TransitionTo(valueobject.StatusInProgress); err == nil {
		t.Fatal("expected error transitioning from COMPLETED")
	}
}
