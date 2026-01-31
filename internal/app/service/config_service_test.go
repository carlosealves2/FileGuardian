package service_test

import (
	"context"
	"testing"

	"github.com/carlosealves2/FileGuardian/internal/app/service"
	"github.com/carlosealves2/FileGuardian/internal/config"
	"github.com/carlosealves2/FileGuardian/internal/ports/driven/mock"
	"github.com/carlosealves2/FileGuardian/internal/ports/driving"
)

func newTestConfigService(cfg config.Config, dbValues map[string]map[string]string, secrets map[string]string, activeProvider string) *service.ConfigService {
	configRepo := &mock.ConfigRepository{
		GetFn: func(ctx context.Context, provider, key string) (string, error) {
			if m, ok := dbValues[provider]; ok {
				return m[key], nil
			}
			return "", nil
		},
		SetFn: func(ctx context.Context, provider, key, value string) error {
			if dbValues[provider] == nil {
				dbValues[provider] = make(map[string]string)
			}
			dbValues[provider][key] = value
			return nil
		},
		GetAllFn: func(ctx context.Context, provider string) (map[string]string, error) {
			if m, ok := dbValues[provider]; ok {
				return m, nil
			}
			return map[string]string{}, nil
		},
		DeleteByProviderFn: func(ctx context.Context, provider string) error {
			delete(dbValues, provider)
			return nil
		},
		GetActiveProviderFn: func(ctx context.Context) (string, error) {
			return activeProvider, nil
		},
		SetActiveProviderFn: func(ctx context.Context, provider string) error {
			activeProvider = provider
			return nil
		},
	}

	secretStore := &mock.SecretStore{
		SetFn: func(provider, key, value string) error {
			secrets[provider+"/"+key] = value
			return nil
		},
		GetFn: func(provider, key string) (string, error) {
			return secrets[provider+"/"+key], nil
		},
		DeleteFn: func(provider, key string) error {
			delete(secrets, provider+"/"+key)
			return nil
		},
	}

	return service.NewConfigService(cfg, configRepo, secretStore)
}

func TestConfigService_GetConfig(t *testing.T) {
	cfg := config.Config{
		UploadPartSize:      5 * 1024 * 1024,
		UploadMaxConcurrent: 5,
		GRPCPort:            50051,
	}

	svc := newTestConfigService(cfg, nil, nil, "S3")
	resp, err := svc.GetConfig(context.Background())
	if err != nil {
		t.Fatalf("get config: %v", err)
	}

	if resp.ActiveProvider != "S3" {
		t.Errorf("expected S3, got %s", resp.ActiveProvider)
	}
	if resp.GRPCPort != 50051 {
		t.Errorf("expected 50051, got %d", resp.GRPCPort)
	}
}

func TestConfigService_GetConfig_NoActiveProvider(t *testing.T) {
	cfg := config.Config{GRPCPort: 50051}

	svc := newTestConfigService(cfg, nil, nil, "")
	resp, err := svc.GetConfig(context.Background())
	if err != nil {
		t.Fatalf("get config: %v", err)
	}

	if resp.ActiveProvider != "" {
		t.Errorf("expected empty active provider, got %s", resp.ActiveProvider)
	}
}

func TestConfigService_ListProviders(t *testing.T) {
	cfg := config.Config{}

	dbValues := map[string]map[string]string{
		"S3": {"region": "us-east-1", "bucket": "my-bucket"},
	}

	svc := newTestConfigService(cfg, dbValues, map[string]string{}, "S3")
	providers, err := svc.ListProviders(context.Background())
	if err != nil {
		t.Fatalf("list: %v", err)
	}

	if len(providers) == 0 {
		t.Fatal("expected at least one provider")
	}

	s3 := providers[0]
	if s3.Name != "S3" {
		t.Errorf("expected S3, got %s", s3.Name)
	}
	if !s3.Active {
		t.Error("expected S3 to be active")
	}

	var regionField *driving.ProviderField
	for _, f := range s3.Fields {
		if f.Key == "region" {
			regionField = &f
			break
		}
	}
	if regionField == nil {
		t.Fatal("expected region field")
	}
	if regionField.Value != "us-east-1" {
		t.Errorf("expected region us-east-1, got %s", regionField.Value)
	}
}

func TestConfigService_ListProviders_DBValues(t *testing.T) {
	cfg := config.Config{}

	dbValues := map[string]map[string]string{
		"S3": {"region": "eu-west-1"},
	}

	svc := newTestConfigService(cfg, dbValues, map[string]string{}, "S3")
	providers, _ := svc.ListProviders(context.Background())

	for _, f := range providers[0].Fields {
		if f.Key == "region" {
			if f.Value != "eu-west-1" {
				t.Errorf("expected DB value eu-west-1, got %s", f.Value)
			}
			return
		}
	}
	t.Fatal("region field not found")
}

func TestConfigService_ListProviders_SecretsMasked(t *testing.T) {
	cfg := config.Config{}
	secrets := map[string]string{"S3/access_key_id": "AKIA123"}

	svc := newTestConfigService(cfg, map[string]map[string]string{}, secrets, "S3")
	providers, _ := svc.ListProviders(context.Background())

	for _, f := range providers[0].Fields {
		if f.Key == "access_key_id" {
			if f.Value != "••••••••" {
				t.Errorf("expected masked value, got %s", f.Value)
			}
			return
		}
	}
	t.Fatal("access_key_id field not found")
}

func TestConfigService_UpdateProviderConfig(t *testing.T) {
	cfg := config.Config{}
	dbValues := map[string]map[string]string{}
	secrets := map[string]string{}

	svc := newTestConfigService(cfg, dbValues, secrets, "")

	err := svc.UpdateProviderConfig(context.Background(), driving.UpdateProviderConfigRequest{
		Provider: "S3",
		Fields: []driving.ProviderFieldValue{
			{Key: "region", Value: "eu-central-1"},
			{Key: "bucket", Value: "new-bucket"},
			{Key: "access_key_id", Value: "AKIA999"},
			{Key: "secret_access_key", Value: "supersecret"},
		},
	})
	if err != nil {
		t.Fatalf("update: %v", err)
	}

	// Non-secrets go to DB
	if dbValues["S3"]["region"] != "eu-central-1" {
		t.Errorf("expected region in DB, got %s", dbValues["S3"]["region"])
	}
	if dbValues["S3"]["bucket"] != "new-bucket" {
		t.Errorf("expected bucket in DB, got %s", dbValues["S3"]["bucket"])
	}

	// Secrets go to keychain
	if secrets["S3/access_key_id"] != "AKIA999" {
		t.Errorf("expected access_key_id in secrets, got %s", secrets["S3/access_key_id"])
	}
	if secrets["S3/secret_access_key"] != "supersecret" {
		t.Errorf("expected secret_access_key in secrets, got %s", secrets["S3/secret_access_key"])
	}

	// DB should NOT have secrets
	if _, exists := dbValues["S3"]["access_key_id"]; exists {
		t.Error("secret should not be in DB")
	}
}

func TestConfigService_UpdateProviderConfig_SetActive(t *testing.T) {
	cfg := config.Config{}
	dbValues := map[string]map[string]string{}
	activeProvider := ""

	configRepo := &mock.ConfigRepository{
		GetFn: func(ctx context.Context, provider, key string) (string, error) {
			return "", nil
		},
		SetFn: func(ctx context.Context, provider, key, value string) error {
			if dbValues[provider] == nil {
				dbValues[provider] = make(map[string]string)
			}
			dbValues[provider][key] = value
			return nil
		},
		GetAllFn: func(ctx context.Context, provider string) (map[string]string, error) {
			return map[string]string{}, nil
		},
		DeleteByProviderFn: func(ctx context.Context, provider string) error {
			return nil
		},
		GetActiveProviderFn: func(ctx context.Context) (string, error) {
			return activeProvider, nil
		},
		SetActiveProviderFn: func(ctx context.Context, provider string) error {
			activeProvider = provider
			return nil
		},
	}

	secretStore := &mock.SecretStore{
		SetFn:    func(provider, key, value string) error { return nil },
		GetFn:    func(provider, key string) (string, error) { return "", nil },
		DeleteFn: func(provider, key string) error { return nil },
	}

	svc := service.NewConfigService(cfg, configRepo, secretStore)

	err := svc.UpdateProviderConfig(context.Background(), driving.UpdateProviderConfigRequest{
		Provider:  "S3",
		Fields:    []driving.ProviderFieldValue{{Key: "region", Value: "us-east-1"}},
		SetActive: true,
	})
	if err != nil {
		t.Fatalf("update: %v", err)
	}

	if activeProvider != "S3" {
		t.Errorf("expected active provider S3, got %s", activeProvider)
	}
}

func TestConfigService_UpdateProviderConfig_UnknownProvider(t *testing.T) {
	cfg := config.Config{}
	svc := newTestConfigService(cfg, map[string]map[string]string{}, map[string]string{}, "")

	err := svc.UpdateProviderConfig(context.Background(), driving.UpdateProviderConfigRequest{
		Provider: "NONEXISTENT",
		Fields:   []driving.ProviderFieldValue{{Key: "foo", Value: "bar"}},
	})
	if err == nil {
		t.Fatal("expected error for unknown provider")
	}
}

func TestConfigService_UpdateProviderConfig_UnknownField(t *testing.T) {
	cfg := config.Config{}
	svc := newTestConfigService(cfg, map[string]map[string]string{}, map[string]string{}, "")

	err := svc.UpdateProviderConfig(context.Background(), driving.UpdateProviderConfigRequest{
		Provider: "S3",
		Fields:   []driving.ProviderFieldValue{{Key: "nonexistent_field", Value: "bar"}},
	})
	if err == nil {
		t.Fatal("expected error for unknown field")
	}
}
