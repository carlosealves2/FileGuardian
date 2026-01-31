package mock

type FileLock struct {
	AcquireFn func() error
	ReleaseFn func() error
}

func (m *FileLock) Acquire() error { return m.AcquireFn() }
func (m *FileLock) Release() error { return m.ReleaseFn() }
