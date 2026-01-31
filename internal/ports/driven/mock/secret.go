package mock

type SecretStore struct {
	SetFn    func(provider, key, value string) error
	GetFn    func(provider, key string) (string, error)
	DeleteFn func(provider, key string) error
}

func (m *SecretStore) Set(provider, key, value string) error {
	return m.SetFn(provider, key, value)
}
func (m *SecretStore) Get(provider, key string) (string, error) {
	return m.GetFn(provider, key)
}
func (m *SecretStore) Delete(provider, key string) error {
	return m.DeleteFn(provider, key)
}
