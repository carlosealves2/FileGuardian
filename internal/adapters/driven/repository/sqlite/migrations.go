package sqlite

import (
	"context"
	"database/sql"
	"fmt"
)

var migrations = []string{
	`CREATE TABLE IF NOT EXISTS processes (
		id TEXT PRIMARY KEY,
		type TEXT NOT NULL,
		status TEXT NOT NULL,
		provider TEXT NOT NULL,
		source_path TEXT NOT NULL,
		created_at DATETIME NOT NULL,
		updated_at DATETIME NOT NULL
	);`,
	`CREATE TABLE IF NOT EXISTS uploads (
		id TEXT PRIMARY KEY,
		process_id TEXT NOT NULL REFERENCES processes(id),
		file_path TEXT NOT NULL,
		storage_key TEXT NOT NULL,
		file_size INTEGER NOT NULL,
		bytes_uploaded INTEGER NOT NULL DEFAULT 0,
		status TEXT NOT NULL,
		error_message TEXT NOT NULL DEFAULT '',
		checksum TEXT NOT NULL DEFAULT '',
		multipart_upload_id TEXT NOT NULL DEFAULT '',
		completed_parts TEXT NOT NULL DEFAULT '[]',
		created_at DATETIME NOT NULL,
		updated_at DATETIME NOT NULL
	);`,
	`CREATE INDEX IF NOT EXISTS idx_uploads_process_id ON uploads(process_id);`,
	`CREATE INDEX IF NOT EXISTS idx_processes_created_at_id ON processes(created_at, id);`,
	`CREATE TABLE IF NOT EXISTS schema_migrations (
		version INTEGER PRIMARY KEY
	);`,
	`CREATE TABLE IF NOT EXISTS provider_configs (
		provider TEXT NOT NULL,
		key TEXT NOT NULL,
		value TEXT NOT NULL DEFAULT '',
		PRIMARY KEY (provider, key)
	);`,
	`CREATE TABLE IF NOT EXISTS app_settings (
		key TEXT PRIMARY KEY,
		value TEXT NOT NULL DEFAULT ''
	);`,
}

func RunMigrations(ctx context.Context, db *sql.DB) error {
	// Ensure schema_migrations table exists first
	_, err := db.ExecContext(ctx, `CREATE TABLE IF NOT EXISTS schema_migrations (version INTEGER PRIMARY KEY)`)
	if err != nil {
		return fmt.Errorf("creating schema_migrations table: %w", err)
	}

	var currentVersion int
	row := db.QueryRowContext(ctx, "SELECT COALESCE(MAX(version), 0) FROM schema_migrations")
	if err := row.Scan(&currentVersion); err != nil {
		return fmt.Errorf("reading current migration version: %w", err)
	}

	for i := currentVersion; i < len(migrations); i++ {
		tx, err := db.BeginTx(ctx, nil)
		if err != nil {
			return fmt.Errorf("beginning transaction for migration %d: %w", i+1, err)
		}

		if _, err := tx.ExecContext(ctx, migrations[i]); err != nil {
			_ = tx.Rollback()
			return fmt.Errorf("running migration %d: %w", i+1, err)
		}

		if _, err := tx.ExecContext(ctx, "INSERT INTO schema_migrations (version) VALUES (?)", i+1); err != nil {
			_ = tx.Rollback()
			return fmt.Errorf("recording migration %d: %w", i+1, err)
		}

		if err := tx.Commit(); err != nil {
			return fmt.Errorf("committing migration %d: %w", i+1, err)
		}
	}

	return nil
}
