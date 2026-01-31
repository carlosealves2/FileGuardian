package filelock

import (
	"fmt"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"syscall"

	"github.com/carlosealves2/FileGuardian/internal/domain"
)

type PIDFileLock struct {
	path string
}

func NewPIDFileLock(path string) *PIDFileLock {
	return &PIDFileLock{path: path}
}

func (l *PIDFileLock) Acquire() error {
	if err := os.MkdirAll(filepath.Dir(l.path), 0o750); err != nil {
		return fmt.Errorf("creating lock directory: %w", err)
	}

	if data, err := os.ReadFile(l.path); err == nil {
		pidStr := strings.TrimSpace(string(data))
		if pid, err := strconv.Atoi(pidStr); err == nil {
			if isProcessRunning(pid) {
				return domain.ErrInstanceAlreadyRunning
			}
		}
		// Stale lock file - remove it
		_ = os.Remove(l.path)
	}

	pid := os.Getpid()
	if err := os.WriteFile(l.path, []byte(strconv.Itoa(pid)), 0o600); err != nil {
		return fmt.Errorf("writing lock file: %w", err)
	}

	return nil
}

func (l *PIDFileLock) Release() error {
	return os.Remove(l.path)
}

func isProcessRunning(pid int) bool {
	process, err := os.FindProcess(pid)
	if err != nil {
		return false
	}
	err = process.Signal(syscall.Signal(0))
	return err == nil
}
