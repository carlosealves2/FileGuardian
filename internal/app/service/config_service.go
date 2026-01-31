package service

import (
	"context"
	"fmt"

	"github.com/carlosealves2/FileGuardian/internal/config"
	"github.com/carlosealves2/FileGuardian/internal/domain"
	"github.com/carlosealves2/FileGuardian/internal/ports/driven"
	"github.com/carlosealves2/FileGuardian/internal/ports/driving"
)

type ConfigService struct {
	cfg        config.Config
	configRepo driven.ConfigRepository
	secrets    driven.SecretStore
}

func NewConfigService(cfg config.Config, configRepo driven.ConfigRepository, secrets driven.SecretStore) *ConfigService {
	return &ConfigService{
		cfg:        cfg,
		configRepo: configRepo,
		secrets:    secrets,
	}
}

func (s *ConfigService) GetConfig(ctx context.Context) (driving.ConfigResponse, error) {
	activeProvider, err := s.configRepo.GetActiveProvider(ctx)
	if err != nil {
		return driving.ConfigResponse{}, fmt.Errorf("reading active provider: %w", err)
	}

	return driving.ConfigResponse{
		ActiveProvider:      activeProvider,
		UploadPartSize:      s.cfg.UploadPartSize,
		UploadMaxConcurrent: s.cfg.UploadMaxConcurrent,
		GRPCPort:            s.cfg.GRPCPort,
	}, nil
}

func (s *ConfigService) ListProviders(ctx context.Context) ([]driving.Provider, error) {
	registry := config.ProviderRegistry()

	activeProvider, err := s.configRepo.GetActiveProvider(ctx)
	if err != nil {
		return nil, fmt.Errorf("reading active provider: %w", err)
	}

	providers := make([]driving.Provider, len(registry))

	for i, schema := range registry {
		dbValues, err := s.configRepo.GetAll(ctx, schema.Name)
		if err != nil {
			return nil, fmt.Errorf("reading config for provider %s: %w", schema.Name, err)
		}

		fields := make([]driving.ProviderField, len(schema.Fields))
		for j, f := range schema.Fields {
			var value string
			if f.Type == config.FieldTypeSecret {
				stored, _ := s.secrets.Get(schema.Name, f.Key)
				if stored != "" {
					value = "••••••••"
				}
			} else {
				value = dbValues[f.Key]
			}

			fields[j] = driving.ProviderField{
				Key:         f.Key,
				Label:       f.Label,
				Type:        driving.FieldType(f.Type),
				Required:    f.Required,
				Value:       value,
				Placeholder: f.Placeholder,
			}
		}

		providers[i] = driving.Provider{
			Name:        schema.Name,
			DisplayName: schema.DisplayName,
			Active:      schema.Name == activeProvider,
			Fields:      fields,
		}
	}

	return providers, nil
}

func (s *ConfigService) UpdateProviderConfig(ctx context.Context, req driving.UpdateProviderConfigRequest) error {
	// Validate provider exists in registry
	registry := config.ProviderRegistry()
	var schema *config.ProviderSchema
	for _, r := range registry {
		if r.Name == req.Provider {
			schema = &r
			break
		}
	}
	if schema == nil {
		return fmt.Errorf("%w: %s", domain.ErrUnsupportedProvider, req.Provider)
	}

	// Build a lookup of field schemas by key
	fieldSchemas := make(map[string]config.ProviderFieldSchema, len(schema.Fields))
	for _, f := range schema.Fields {
		fieldSchemas[f.Key] = f
	}

	for _, field := range req.Fields {
		fs, ok := fieldSchemas[field.Key]
		if !ok {
			return fmt.Errorf("%w: unknown field %q for provider %s", domain.ErrInvalidInput, field.Key, req.Provider)
		}

		if fs.Type == config.FieldTypeSecret {
			if err := s.secrets.Set(req.Provider, field.Key, field.Value); err != nil {
				return fmt.Errorf("storing secret %q: %w", field.Key, err)
			}
		} else {
			if err := s.configRepo.Set(ctx, req.Provider, field.Key, field.Value); err != nil {
				return fmt.Errorf("storing config %q: %w", field.Key, err)
			}
		}
	}

	if req.SetActive {
		if err := s.configRepo.SetActiveProvider(ctx, req.Provider); err != nil {
			return fmt.Errorf("setting active provider: %w", err)
		}
	}

	return nil
}
