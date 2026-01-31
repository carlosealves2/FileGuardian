package sqlite_test

import (
	"context"
	"database/sql"
	"testing"

	"github.com/carlosealves2/FileGuardian/internal/adapters/driven/repository/sqlite"
	_ "modernc.org/sqlite"
)

func setupTestDB(t *testing.T) *sql.DB {
	t.Helper()

	db, err := sql.Open("sqlite", ":memory:")
	if err != nil {
		t.Fatalf("opening test db: %v", err)
	}
	t.Cleanup(func() { db.Close() })

	if err := sqlite.RunMigrations(context.Background(), db); err != nil {
		t.Fatalf("running migrations: %v", err)
	}

	return db
}
