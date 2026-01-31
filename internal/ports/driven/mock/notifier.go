package mock

type Notifier struct {
	NotifyFn func(title, message string) error
}

func (m *Notifier) Notify(title, message string) error {
	return m.NotifyFn(title, message)
}
