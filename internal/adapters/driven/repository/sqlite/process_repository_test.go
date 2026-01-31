package sqlite_test

import (
	"context"
	"testing"

	"github.com/carlosealves2/FileGuardian/internal/adapters/driven/repository/sqlite"
	"github.com/carlosealves2/FileGuardian/internal/domain"
	"github.com/carlosealves2/FileGuardian/internal/domain/entity"
	"github.com/carlosealves2/FileGuardian/internal/domain/valueobject"
)

func TestProcessRepository_CreateAndGetByID(t *testing.T) {
	db := setupTestDB(t)
	repo := sqlite.NewProcessRepository(db)
	ctx := context.Background()

	p := entity.NewProcess("p1", valueobject.ProcessTypeFile, "S3", "/tmp/file.txt")

	if err := repo.Create(ctx, p); err != nil {
		t.Fatalf("create: %v", err)
	}

	got, err := repo.GetByID(ctx, "p1")
	if err != nil {
		t.Fatalf("get by id: %v", err)
	}

	if got.ID != "p1" {
		t.Errorf("expected ID p1, got %s", got.ID)
	}
	if got.Type != valueobject.ProcessTypeFile {
		t.Errorf("expected FILE, got %s", got.Type)
	}
	if got.Status != valueobject.StatusPending {
		t.Errorf("expected PENDING, got %s", got.Status)
	}
	if got.Provider != "S3" {
		t.Errorf("expected S3, got %s", got.Provider)
	}
}

func TestProcessRepository_GetByID_NotFound(t *testing.T) {
	db := setupTestDB(t)
	repo := sqlite.NewProcessRepository(db)

	_, err := repo.GetByID(context.Background(), "nonexistent")
	if err != domain.ErrNotFound {
		t.Fatalf("expected ErrNotFound, got: %v", err)
	}
}

func TestProcessRepository_Update(t *testing.T) {
	db := setupTestDB(t)
	repo := sqlite.NewProcessRepository(db)
	ctx := context.Background()

	p := entity.NewProcess("p1", valueobject.ProcessTypeFile, "S3", "/tmp/file.txt")
	repo.Create(ctx, p)

	p.TransitionTo(valueobject.StatusInProgress)
	if err := repo.Update(ctx, p); err != nil {
		t.Fatalf("update: %v", err)
	}

	got, _ := repo.GetByID(ctx, "p1")
	if got.Status != valueobject.StatusInProgress {
		t.Errorf("expected IN_PROGRESS, got %s", got.Status)
	}
}

func TestProcessRepository_Update_NotFound(t *testing.T) {
	db := setupTestDB(t)
	repo := sqlite.NewProcessRepository(db)

	p := entity.NewProcess("nonexistent", valueobject.ProcessTypeFile, "S3", "/tmp/file.txt")
	err := repo.Update(context.Background(), p)
	if err != domain.ErrNotFound {
		t.Fatalf("expected ErrNotFound, got: %v", err)
	}
}

func TestProcessRepository_List(t *testing.T) {
	db := setupTestDB(t)
	repo := sqlite.NewProcessRepository(db)
	ctx := context.Background()

	for i := range 5 {
		p := entity.NewProcess(
			"p"+string(rune('a'+i)),
			valueobject.ProcessTypeFile,
			"S3",
			"/tmp/file.txt",
		)
		repo.Create(ctx, p)
	}

	// First page
	processes, cursor, err := repo.List(ctx, "", 3)
	if err != nil {
		t.Fatalf("list: %v", err)
	}
	if len(processes) != 3 {
		t.Fatalf("expected 3, got %d", len(processes))
	}
	if cursor == "" {
		t.Fatal("expected non-empty cursor")
	}

	// Second page
	processes2, cursor2, err := repo.List(ctx, cursor, 3)
	if err != nil {
		t.Fatalf("list page 2: %v", err)
	}
	if len(processes2) != 2 {
		t.Fatalf("expected 2, got %d", len(processes2))
	}
	if cursor2 != "" {
		t.Errorf("expected empty cursor for last page, got %s", cursor2)
	}
}
