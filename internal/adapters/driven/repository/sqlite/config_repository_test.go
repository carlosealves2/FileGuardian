package sqlite_test

import (
	"context"
	"testing"

	"github.com/carlosealves2/FileGuardian/internal/adapters/driven/repository/sqlite"
)

func TestConfigRepository_SetAndGet(t *testing.T) {
	db := setupTestDB(t)
	repo := sqlite.NewConfigRepository(db)
	ctx := context.Background()

	if err := repo.Set(ctx, "S3", "region", "us-east-1"); err != nil {
		t.Fatalf("set: %v", err)
	}

	val, err := repo.Get(ctx, "S3", "region")
	if err != nil {
		t.Fatalf("get: %v", err)
	}
	if val != "us-east-1" {
		t.Errorf("expected us-east-1, got %s", val)
	}
}

func TestConfigRepository_Get_NotFound(t *testing.T) {
	db := setupTestDB(t)
	repo := sqlite.NewConfigRepository(db)

	val, err := repo.Get(context.Background(), "S3", "nonexistent")
	if err != nil {
		t.Fatalf("get: %v", err)
	}
	if val != "" {
		t.Errorf("expected empty string, got %s", val)
	}
}

func TestConfigRepository_Set_Upsert(t *testing.T) {
	db := setupTestDB(t)
	repo := sqlite.NewConfigRepository(db)
	ctx := context.Background()

	repo.Set(ctx, "S3", "region", "us-east-1")
	repo.Set(ctx, "S3", "region", "eu-west-1")

	val, _ := repo.Get(ctx, "S3", "region")
	if val != "eu-west-1" {
		t.Errorf("expected eu-west-1 after upsert, got %s", val)
	}
}

func TestConfigRepository_GetAll(t *testing.T) {
	db := setupTestDB(t)
	repo := sqlite.NewConfigRepository(db)
	ctx := context.Background()

	repo.Set(ctx, "S3", "region", "us-east-1")
	repo.Set(ctx, "S3", "bucket", "my-bucket")
	repo.Set(ctx, "AZURE", "account", "myaccount")

	vals, err := repo.GetAll(ctx, "S3")
	if err != nil {
		t.Fatalf("getall: %v", err)
	}
	if len(vals) != 2 {
		t.Fatalf("expected 2 values for S3, got %d", len(vals))
	}
	if vals["region"] != "us-east-1" {
		t.Errorf("expected region us-east-1, got %s", vals["region"])
	}
	if vals["bucket"] != "my-bucket" {
		t.Errorf("expected bucket my-bucket, got %s", vals["bucket"])
	}
}

func TestConfigRepository_DeleteByProvider(t *testing.T) {
	db := setupTestDB(t)
	repo := sqlite.NewConfigRepository(db)
	ctx := context.Background()

	repo.Set(ctx, "S3", "region", "us-east-1")
	repo.Set(ctx, "S3", "bucket", "my-bucket")
	repo.Set(ctx, "AZURE", "account", "myaccount")

	if err := repo.DeleteByProvider(ctx, "S3"); err != nil {
		t.Fatalf("delete: %v", err)
	}

	vals, _ := repo.GetAll(ctx, "S3")
	if len(vals) != 0 {
		t.Errorf("expected 0 values after delete, got %d", len(vals))
	}

	// AZURE should be untouched
	azureVals, _ := repo.GetAll(ctx, "AZURE")
	if len(azureVals) != 1 {
		t.Errorf("expected 1 AZURE value, got %d", len(azureVals))
	}
}

func TestConfigRepository_GetActiveProvider_Empty(t *testing.T) {
	db := setupTestDB(t)
	repo := sqlite.NewConfigRepository(db)

	val, err := repo.GetActiveProvider(context.Background())
	if err != nil {
		t.Fatalf("get active provider: %v", err)
	}
	if val != "" {
		t.Errorf("expected empty string, got %s", val)
	}
}

func TestConfigRepository_SetAndGetActiveProvider(t *testing.T) {
	db := setupTestDB(t)
	repo := sqlite.NewConfigRepository(db)
	ctx := context.Background()

	if err := repo.SetActiveProvider(ctx, "S3"); err != nil {
		t.Fatalf("set active provider: %v", err)
	}

	val, err := repo.GetActiveProvider(ctx)
	if err != nil {
		t.Fatalf("get active provider: %v", err)
	}
	if val != "S3" {
		t.Errorf("expected S3, got %s", val)
	}
}

func TestConfigRepository_SetActiveProvider_Upsert(t *testing.T) {
	db := setupTestDB(t)
	repo := sqlite.NewConfigRepository(db)
	ctx := context.Background()

	repo.SetActiveProvider(ctx, "S3")
	repo.SetActiveProvider(ctx, "AZURE")

	val, _ := repo.GetActiveProvider(ctx)
	if val != "AZURE" {
		t.Errorf("expected AZURE after upsert, got %s", val)
	}
}
