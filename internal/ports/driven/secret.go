package driven

// SecretStore persists sensitive credentials using the OS keychain.
type SecretStore interface {
	Set(provider, key, value string) error
	Get(provider, key string) (string, error)
	Delete(provider, key string) error
}
