package entity_test

import (
	"testing"

	"github.com/carlosealves2/FileGuardian/internal/domain"
	"github.com/carlosealves2/FileGuardian/internal/domain/entity"
	"github.com/carlosealves2/FileGuardian/internal/domain/valueobject"
)

func TestNewProcess(t *testing.T) {
	p := entity.NewProcess("p1", valueobject.ProcessTypeFile, "S3", "/tmp/file.txt")

	if p.ID != "p1" {
		t.Errorf("expected ID p1, got %s", p.ID)
	}
	if p.Status != valueobject.StatusPending {
		t.Errorf("expected PENDING, got %s", p.Status)
	}
	if p.Provider != "S3" {
		t.Errorf("expected S3, got %s", p.Provider)
	}
}

func TestProcess_Pause(t *testing.T) {
	p := entity.NewProcess("p1", valueobject.ProcessTypeFile, "S3", "/tmp/file.txt")

	// Cannot pause from PENDING
	if err := p.Pause(); err == nil {
		t.Fatal("expected error pausing from PENDING")
	}

	// Move to IN_PROGRESS, then pause
	_ = p.TransitionTo(valueobject.StatusInProgress)
	if err := p.Pause(); err != nil {
		t.Fatalf("expected pause to succeed: %v", err)
	}
	if p.Status != valueobject.StatusPaused {
		t.Errorf("expected PAUSED, got %s", p.Status)
	}
}

func TestProcess_Resume(t *testing.T) {
	p := entity.NewProcess("p1", valueobject.ProcessTypeFile, "S3", "/tmp/file.txt")
	_ = p.TransitionTo(valueobject.StatusInProgress)
	_ = p.Pause()

	if err := p.Resume(); err != nil {
		t.Fatalf("expected resume to succeed: %v", err)
	}
	if p.Status != valueobject.StatusInProgress {
		t.Errorf("expected IN_PROGRESS, got %s", p.Status)
	}
}

func TestProcess_Cancel(t *testing.T) {
	p := entity.NewProcess("p1", valueobject.ProcessTypeFile, "S3", "/tmp/file.txt")
	_ = p.TransitionTo(valueobject.StatusInProgress)

	if err := p.Cancel(); err != nil {
		t.Fatalf("expected cancel to succeed: %v", err)
	}
	if p.Status != valueobject.StatusCancelled {
		t.Errorf("expected CANCELLED, got %s", p.Status)
	}
}

func TestProcess_CancelFromPaused(t *testing.T) {
	p := entity.NewProcess("p1", valueobject.ProcessTypeFile, "S3", "/tmp/file.txt")
	_ = p.TransitionTo(valueobject.StatusInProgress)
	_ = p.Pause()

	if err := p.Cancel(); err != nil {
		t.Fatalf("expected cancel from PAUSED to succeed: %v", err)
	}
	if p.Status != valueobject.StatusCancelled {
		t.Errorf("expected CANCELLED, got %s", p.Status)
	}
}

func TestProcess_CannotCancelFromCompleted(t *testing.T) {
	p := entity.NewProcess("p1", valueobject.ProcessTypeFile, "S3", "/tmp/file.txt")
	_ = p.TransitionTo(valueobject.StatusInProgress)
	_ = p.TransitionTo(valueobject.StatusCompleted)

	err := p.Cancel()
	if err == nil {
		t.Fatal("expected error cancelling from COMPLETED")
	}
	if err != domain.ErrProcessNotCancellable {
		t.Errorf("expected ErrProcessNotCancellable, got: %v", err)
	}
}

func TestDeriveProcessStatus(t *testing.T) {
	tests := []struct {
		name     string
		uploads  []entity.Upload
		expected valueobject.Status
	}{
		{
			name:     "empty uploads",
			uploads:  nil,
			expected: valueobject.StatusPending,
		},
		{
			name: "all completed",
			uploads: []entity.Upload{
				{Status: valueobject.StatusCompleted},
				{Status: valueobject.StatusCompleted},
			},
			expected: valueobject.StatusCompleted,
		},
		{
			name: "one in progress",
			uploads: []entity.Upload{
				{Status: valueobject.StatusCompleted},
				{Status: valueobject.StatusInProgress},
			},
			expected: valueobject.StatusInProgress,
		},
		{
			name: "one paused, none in progress",
			uploads: []entity.Upload{
				{Status: valueobject.StatusCompleted},
				{Status: valueobject.StatusPaused},
			},
			expected: valueobject.StatusPaused,
		},
		{
			name: "all cancelled",
			uploads: []entity.Upload{
				{Status: valueobject.StatusCancelled},
				{Status: valueobject.StatusCancelled},
			},
			expected: valueobject.StatusCancelled,
		},
		{
			name: "all failed no pending",
			uploads: []entity.Upload{
				{Status: valueobject.StatusFailed},
				{Status: valueobject.StatusFailed},
			},
			expected: valueobject.StatusFailed,
		},
		{
			name: "failed and pending",
			uploads: []entity.Upload{
				{Status: valueobject.StatusFailed},
				{Status: valueobject.StatusPending},
			},
			expected: valueobject.StatusInProgress,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := entity.DeriveProcessStatus(tt.uploads)
			if result != tt.expected {
				t.Errorf("expected %s, got %s", tt.expected, result)
			}
		})
	}
}
