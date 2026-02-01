package config

import (
	"os"
	"path/filepath"
	"strconv"
)

type Config struct {
	GRPCPort             int32
	UploadPartSize       int64
	UploadMaxConcurrent  int32
	UploadPartsParallel  int32
	DBPath               string
	LockPath             string
}

// FieldType defines the data type of a provider configuration field.
type FieldType int32

const (
	FieldTypeString  FieldType = 1
	FieldTypeSecret  FieldType = 2
	FieldTypeNumber  FieldType = 3
	FieldTypeBoolean FieldType = 4
)

// ProviderFieldSchema describes a single configuration field for a provider.
type ProviderFieldSchema struct {
	Key         string
	Label       string
	Type        FieldType
	Required    bool
	Placeholder string
}

// ProviderSchema describes a storage provider and its required fields.
type ProviderSchema struct {
	Name        string
	DisplayName string
	Fields      []ProviderFieldSchema
}

// ProviderRegistry returns all registered providers with their field schemas.
// When adding a new provider, add its schema here.
func ProviderRegistry() []ProviderSchema {
	return []ProviderSchema{
		{
			Name:        "S3",
			DisplayName: "Amazon S3",
			Fields: []ProviderFieldSchema{
				{Key: "region", Label: "Region", Type: FieldTypeString, Required: true, Placeholder: "us-east-1"},
				{Key: "bucket", Label: "Bucket", Type: FieldTypeString, Required: true, Placeholder: "my-bucket"},
				{Key: "access_key_id", Label: "Access Key ID", Type: FieldTypeSecret, Required: true, Placeholder: "AKIA..."},
				{Key: "secret_access_key", Label: "Secret Access Key", Type: FieldTypeSecret, Required: true, Placeholder: ""},
				{Key: "endpoint", Label: "Custom Endpoint", Type: FieldTypeString, Required: false, Placeholder: "https://s3.amazonaws.com"},
			},
		},
	}
}

func Load() Config {
	homeDir, _ := os.UserHomeDir()
	defaultDir := filepath.Join(homeDir, ".file-guardian")

	return Config{
		GRPCPort:            getEnv[int32]("GRPC_PORT", 50051),
		UploadPartSize:      getEnv[int64]("UPLOAD_PART_SIZE", 5*1024*1024),
		UploadMaxConcurrent: getEnv[int32]("UPLOAD_MAX_CONCURRENT", 5),
		UploadPartsParallel: getEnv[int32]("UPLOAD_PARTS_PARALLEL", 3),
		DBPath:              getEnv("DB_PATH", filepath.Join(defaultDir, "fileguardian.db")),
		LockPath:            getEnv("LOCK_PATH", filepath.Join(defaultDir, "lock")),
	}
}

type envType interface {
	string | int | int32 | int64
}

func getEnv[T envType](key string, fallback T) T {
	v := os.Getenv(key)
	if v == "" {
		return fallback
	}

	var result any
	switch any(fallback).(type) {
	case string:
		return any(v).(T)
	case int:
		n, err := strconv.Atoi(v)
		if err != nil {
			return fallback
		}
		result = n
	case int32:
		n, err := strconv.ParseInt(v, 10, 32)
		if err != nil {
			return fallback
		}
		result = int32(n)
	case int64:
		n, err := strconv.ParseInt(v, 10, 64)
		if err != nil {
			return fallback
		}
		result = n
	}

	return result.(T)
}
