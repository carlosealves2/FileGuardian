package driven

// FileLock ensures only one instance of the application is running.
type FileLock interface {
	// Acquire attempts to acquire the lock. Returns ErrInstanceAlreadyRunning
	// if another instance holds the lock.
	Acquire() error

	// Release releases the lock and cleans up the lock file.
	Release() error
}
