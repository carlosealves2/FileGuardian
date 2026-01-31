package driving

import "context"

// ConfigService defines the contract for configuration access.
type ConfigService interface {
	GetConfig(ctx context.Context) (ConfigResponse, error)
	ListProviders(ctx context.Context) ([]Provider, error)
	UpdateProviderConfig(ctx context.Context, req UpdateProviderConfigRequest) error
}

// ConfigResponse holds the application configuration values.
type ConfigResponse struct {
	ActiveProvider      string
	UploadPartSize      int64
	UploadMaxConcurrent int32
	GRPCPort            int32
}

// FieldType defines the data type of a provider configuration field.
type FieldType int32

const (
	FieldTypeString  FieldType = 1
	FieldTypeSecret  FieldType = 2
	FieldTypeNumber  FieldType = 3
	FieldTypeBoolean FieldType = 4
)

// ProviderField describes a single configuration field for a storage provider.
type ProviderField struct {
	Key         string
	Label       string
	Type        FieldType
	Required    bool
	Value       string
	Placeholder string
}

// Provider describes a storage provider and its configuration schema.
type Provider struct {
	Name        string
	DisplayName string
	Active      bool
	Fields      []ProviderField
}

// ProviderFieldValue is a key-value pair sent by the client when saving config.
type ProviderFieldValue struct {
	Key   string
	Value string
}

// UpdateProviderConfigRequest holds the data for updating a provider's config.
type UpdateProviderConfigRequest struct {
	Provider  string
	Fields    []ProviderFieldValue
	SetActive bool
}
