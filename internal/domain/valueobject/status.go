package valueobject

import (
	"fmt"

	"github.com/carlosealves2/FileGuardian/internal/domain"
)

type Status string

const (
	StatusPending    Status = "PENDING"
	StatusInProgress Status = "IN_PROGRESS"
	StatusPaused     Status = "PAUSED"
	StatusCompleted  Status = "COMPLETED"
	StatusFailed     Status = "FAILED"
	StatusCancelled  Status = "CANCELLED"
)

// validTransitions defines which state transitions are allowed.
// Key: current status, Value: set of valid next statuses.
var validTransitions = map[Status]map[Status]bool{
	StatusPending: {
		StatusInProgress: true,
		StatusCancelled:  true,
	},
	StatusInProgress: {
		StatusCompleted: true,
		StatusFailed:    true,
		StatusPaused:    true,
		StatusCancelled: true,
	},
	StatusPaused: {
		StatusInProgress: true,
		StatusCancelled:  true,
	},
	StatusFailed: {},
	StatusCompleted: {},
	StatusCancelled: {},
}

func (s Status) CanTransitionTo(next Status) bool {
	allowed, ok := validTransitions[s]
	if !ok {
		return false
	}
	return allowed[next]
}

func (s Status) TransitionTo(next Status) (Status, error) {
	if !s.CanTransitionTo(next) {
		return s, fmt.Errorf("%w: %s -> %s", domain.ErrInvalidStateTransit, s, next)
	}
	return next, nil
}

func (s Status) IsTerminal() bool {
	return s == StatusCompleted || s == StatusFailed || s == StatusCancelled
}

func ParseStatus(s string) (Status, error) {
	switch s {
	case string(StatusPending):
		return StatusPending, nil
	case string(StatusInProgress):
		return StatusInProgress, nil
	case string(StatusPaused):
		return StatusPaused, nil
	case string(StatusCompleted):
		return StatusCompleted, nil
	case string(StatusFailed):
		return StatusFailed, nil
	case string(StatusCancelled):
		return StatusCancelled, nil
	default:
		return "", fmt.Errorf("unknown status: %s", s)
	}
}

func (s Status) String() string {
	return string(s)
}
