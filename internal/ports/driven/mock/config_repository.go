package mock

import "context"

type ConfigRepository struct {
	GetFn                func(ctx context.Context, provider, key string) (string, error)
	SetFn                func(ctx context.Context, provider, key, value string) error
	GetAllFn             func(ctx context.Context, provider string) (map[string]string, error)
	DeleteByProviderFn   func(ctx context.Context, provider string) error
	GetActiveProviderFn  func(ctx context.Context) (string, error)
	SetActiveProviderFn  func(ctx context.Context, provider string) error
}

func (m *ConfigRepository) Get(ctx context.Context, provider, key string) (string, error) {
	return m.GetFn(ctx, provider, key)
}
func (m *ConfigRepository) Set(ctx context.Context, provider, key, value string) error {
	return m.SetFn(ctx, provider, key, value)
}
func (m *ConfigRepository) GetAll(ctx context.Context, provider string) (map[string]string, error) {
	return m.GetAllFn(ctx, provider)
}
func (m *ConfigRepository) DeleteByProvider(ctx context.Context, provider string) error {
	return m.DeleteByProviderFn(ctx, provider)
}
func (m *ConfigRepository) GetActiveProvider(ctx context.Context) (string, error) {
	return m.GetActiveProviderFn(ctx)
}
func (m *ConfigRepository) SetActiveProvider(ctx context.Context, provider string) error {
	return m.SetActiveProviderFn(ctx, provider)
}
