package driven

import "context"

// ConfigRepository persists non-sensitive provider configuration.
type ConfigRepository interface {
	Get(ctx context.Context, provider, key string) (string, error)
	Set(ctx context.Context, provider, key, value string) error
	GetAll(ctx context.Context, provider string) (map[string]string, error)
	DeleteByProvider(ctx context.Context, provider string) error
	GetActiveProvider(ctx context.Context) (string, error)
	SetActiveProvider(ctx context.Context, provider string) error
}
