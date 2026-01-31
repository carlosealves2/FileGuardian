package domain

import "errors"

var (
	ErrNotFound             = errors.New("not found")
	ErrAlreadyExists        = errors.New("already exists")
	ErrInvalidInput         = errors.New("invalid input")
	ErrInvalidStateTransit  = errors.New("invalid state transition")
	ErrProcessNotPausable   = errors.New("process cannot be paused in current state")
	ErrProcessNotResumable  = errors.New("process cannot be resumed in current state")
	ErrProcessNotCancellable = errors.New("process cannot be cancelled in current state")
	ErrUnsupportedProvider  = errors.New("unsupported storage provider")
	ErrInstanceAlreadyRunning = errors.New("another instance is already running")
	ErrChecksumMismatch     = errors.New("checksum mismatch")
	ErrSizeMismatch         = errors.New("file size mismatch after upload")
	ErrNoActiveProvider     = errors.New("no active storage provider configured")
)
