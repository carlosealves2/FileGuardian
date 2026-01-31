package config_test

import (
	"os"
	"testing"

	"github.com/carlosealves2/FileGuardian/internal/config"
)

func TestLoad_Defaults(t *testing.T) {
	envVars := []string{
		"GRPC_PORT", "UPLOAD_PART_SIZE", "UPLOAD_MAX_CONCURRENT",
	}
	for _, v := range envVars {
		os.Unsetenv(v)
	}

	cfg := config.Load()

	if cfg.GRPCPort != 50051 {
		t.Errorf("expected GRPC_PORT 50051, got %d", cfg.GRPCPort)
	}
	if cfg.UploadPartSize != 5*1024*1024 {
		t.Errorf("expected UploadPartSize %d, got %d", 5*1024*1024, cfg.UploadPartSize)
	}
	if cfg.UploadMaxConcurrent != 5 {
		t.Errorf("expected UploadMaxConcurrent 5, got %d", cfg.UploadMaxConcurrent)
	}
}

func TestLoad_FromEnv(t *testing.T) {
	t.Setenv("GRPC_PORT", "9090")
	t.Setenv("UPLOAD_PART_SIZE", "10485760")
	t.Setenv("UPLOAD_MAX_CONCURRENT", "10")

	cfg := config.Load()

	if cfg.GRPCPort != 9090 {
		t.Errorf("expected GRPC_PORT 9090, got %d", cfg.GRPCPort)
	}
	if cfg.UploadPartSize != 10485760 {
		t.Errorf("expected UploadPartSize 10485760, got %d", cfg.UploadPartSize)
	}
	if cfg.UploadMaxConcurrent != 10 {
		t.Errorf("expected UploadMaxConcurrent 10, got %d", cfg.UploadMaxConcurrent)
	}
}

func TestProviderRegistry(t *testing.T) {
	registry := config.ProviderRegistry()

	if len(registry) == 0 {
		t.Fatal("expected at least one provider in registry")
	}

	s3 := registry[0]
	if s3.Name != "S3" {
		t.Errorf("expected first provider S3, got %s", s3.Name)
	}
	if s3.DisplayName != "Amazon S3" {
		t.Errorf("expected display name 'Amazon S3', got %s", s3.DisplayName)
	}
	if len(s3.Fields) != 5 {
		t.Errorf("expected 5 fields for S3, got %d", len(s3.Fields))
	}

	// Verify secret fields exist
	secretCount := 0
	for _, f := range s3.Fields {
		if f.Type == config.FieldTypeSecret {
			secretCount++
		}
	}
	if secretCount != 2 {
		t.Errorf("expected 2 secret fields (access_key_id, secret_access_key), got %d", secretCount)
	}
}
