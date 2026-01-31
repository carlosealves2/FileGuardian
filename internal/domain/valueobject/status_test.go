package valueobject_test

import (
	"errors"
	"testing"

	"github.com/carlosealves2/FileGuardian/internal/domain"
	"github.com/carlosealves2/FileGuardian/internal/domain/valueobject"
)

func TestStatus_ValidTransitions(t *testing.T) {
	tests := []struct {
		from valueobject.Status
		to   valueobject.Status
	}{
		{valueobject.StatusPending, valueobject.StatusInProgress},
		{valueobject.StatusPending, valueobject.StatusCancelled},
		{valueobject.StatusInProgress, valueobject.StatusCompleted},
		{valueobject.StatusInProgress, valueobject.StatusFailed},
		{valueobject.StatusInProgress, valueobject.StatusPaused},
		{valueobject.StatusInProgress, valueobject.StatusCancelled},
		{valueobject.StatusPaused, valueobject.StatusInProgress},
		{valueobject.StatusPaused, valueobject.StatusCancelled},
	}

	for _, tt := range tests {
		t.Run(tt.from.String()+"->"+tt.to.String(), func(t *testing.T) {
			result, err := tt.from.TransitionTo(tt.to)
			if err != nil {
				t.Fatalf("expected valid transition from %s to %s, got error: %v", tt.from, tt.to, err)
			}
			if result != tt.to {
				t.Fatalf("expected %s, got %s", tt.to, result)
			}
		})
	}
}

func TestStatus_InvalidTransitions(t *testing.T) {
	tests := []struct {
		from valueobject.Status
		to   valueobject.Status
	}{
		{valueobject.StatusPending, valueobject.StatusCompleted},
		{valueobject.StatusPending, valueobject.StatusPaused},
		{valueobject.StatusPending, valueobject.StatusFailed},
		{valueobject.StatusCompleted, valueobject.StatusInProgress},
		{valueobject.StatusCompleted, valueobject.StatusFailed},
		{valueobject.StatusFailed, valueobject.StatusInProgress},
		{valueobject.StatusFailed, valueobject.StatusCompleted},
		{valueobject.StatusCancelled, valueobject.StatusInProgress},
		{valueobject.StatusCancelled, valueobject.StatusCompleted},
		{valueobject.StatusPaused, valueobject.StatusCompleted},
		{valueobject.StatusPaused, valueobject.StatusFailed},
	}

	for _, tt := range tests {
		t.Run(tt.from.String()+"->"+tt.to.String(), func(t *testing.T) {
			_, err := tt.from.TransitionTo(tt.to)
			if err == nil {
				t.Fatalf("expected error for transition from %s to %s", tt.from, tt.to)
			}
			if !errors.Is(err, domain.ErrInvalidStateTransit) {
				t.Fatalf("expected ErrInvalidStateTransit, got: %v", err)
			}
		})
	}
}

func TestStatus_IsTerminal(t *testing.T) {
	terminal := []valueobject.Status{
		valueobject.StatusCompleted,
		valueobject.StatusFailed,
		valueobject.StatusCancelled,
	}
	nonTerminal := []valueobject.Status{
		valueobject.StatusPending,
		valueobject.StatusInProgress,
		valueobject.StatusPaused,
	}

	for _, s := range terminal {
		if !s.IsTerminal() {
			t.Errorf("expected %s to be terminal", s)
		}
	}
	for _, s := range nonTerminal {
		if s.IsTerminal() {
			t.Errorf("expected %s to not be terminal", s)
		}
	}
}

func TestParseStatus(t *testing.T) {
	valid := []string{"PENDING", "IN_PROGRESS", "PAUSED", "COMPLETED", "FAILED", "CANCELLED"}
	for _, s := range valid {
		_, err := valueobject.ParseStatus(s)
		if err != nil {
			t.Errorf("expected %s to parse, got error: %v", s, err)
		}
	}

	_, err := valueobject.ParseStatus("UNKNOWN")
	if err == nil {
		t.Error("expected error for unknown status")
	}
}
