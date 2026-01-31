package driven

// Notifier sends system notifications to the user.
type Notifier interface {
	Notify(title, message string) error
}
