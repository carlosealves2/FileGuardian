package entity

import (
	"time"

	"github.com/carlosealves2/FileGuardian/internal/domain"
	"github.com/carlosealves2/FileGuardian/internal/domain/valueobject"
)

type Process struct {
	ID         string
	Type       valueobject.ProcessType
	Status     valueobject.Status
	Provider   string
	SourcePath string
	CreatedAt  time.Time
	UpdatedAt  time.Time
}

func NewProcess(id string, processType valueobject.ProcessType, provider, sourcePath string) Process {
	now := time.Now().UTC()
	return Process{
		ID:         id,
		Type:       processType,
		Status:     valueobject.StatusPending,
		Provider:   provider,
		SourcePath: sourcePath,
		CreatedAt:  now,
		UpdatedAt:  now,
	}
}

func (p *Process) TransitionTo(status valueobject.Status) error {
	next, err := p.Status.TransitionTo(status)
	if err != nil {
		return err
	}
	p.Status = next
	p.UpdatedAt = time.Now().UTC()
	return nil
}

// DeriveStatus computes the process status from its uploads' statuses.
func DeriveProcessStatus(uploads []Upload) valueobject.Status {
	if len(uploads) == 0 {
		return valueobject.StatusPending
	}

	var hasInProgress, hasPaused, hasPending, hasFailed bool
	allCompleted := true
	allCancelled := true

	for _, u := range uploads {
		switch u.Status {
		case valueobject.StatusInProgress:
			hasInProgress = true
			allCompleted = false
			allCancelled = false
		case valueobject.StatusPaused:
			hasPaused = true
			allCompleted = false
			allCancelled = false
		case valueobject.StatusPending:
			hasPending = true
			allCompleted = false
			allCancelled = false
		case valueobject.StatusFailed:
			hasFailed = true
			allCompleted = false
			allCancelled = false
		case valueobject.StatusCancelled:
			allCompleted = false
		case valueobject.StatusCompleted:
			allCancelled = false
		}
	}

	switch {
	case hasInProgress:
		return valueobject.StatusInProgress
	case allCompleted:
		return valueobject.StatusCompleted
	case allCancelled:
		return valueobject.StatusCancelled
	case hasPaused:
		return valueobject.StatusPaused
	case hasFailed && !hasPending:
		return valueobject.StatusFailed
	default:
		return valueobject.StatusInProgress
	}
}

func (p *Process) IsPausable() bool {
	return p.Status == valueobject.StatusInProgress
}

func (p *Process) IsResumable() bool {
	return p.Status == valueobject.StatusPaused
}

func (p *Process) IsCancellable() bool {
	return p.Status == valueobject.StatusInProgress ||
		p.Status == valueobject.StatusPaused ||
		p.Status == valueobject.StatusPending
}

func (p *Process) Pause() error {
	if !p.IsPausable() {
		return domain.ErrProcessNotPausable
	}
	return p.TransitionTo(valueobject.StatusPaused)
}

func (p *Process) Resume() error {
	if !p.IsResumable() {
		return domain.ErrProcessNotResumable
	}
	return p.TransitionTo(valueobject.StatusInProgress)
}

func (p *Process) Cancel() error {
	if !p.IsCancellable() {
		return domain.ErrProcessNotCancellable
	}
	return p.TransitionTo(valueobject.StatusCancelled)
}
