package sqlite

import (
	"context"
	"database/sql"
	"fmt"
)

type ConfigRepository struct {
	db *sql.DB
}

func NewConfigRepository(db *sql.DB) *ConfigRepository {
	return &ConfigRepository{db: db}
}

func (r *ConfigRepository) Get(ctx context.Context, provider, key string) (string, error) {
	var value string
	err := r.db.QueryRowContext(ctx,
		"SELECT value FROM provider_configs WHERE provider = ? AND key = ?",
		provider, key,
	).Scan(&value)
	if err != nil {
		if err == sql.ErrNoRows {
			return "", nil
		}
		return "", fmt.Errorf("getting config: %w", err)
	}
	return value, nil
}

func (r *ConfigRepository) Set(ctx context.Context, provider, key, value string) error {
	_, err := r.db.ExecContext(ctx,
		`INSERT INTO provider_configs (provider, key, value) VALUES (?, ?, ?)
		 ON CONFLICT(provider, key) DO UPDATE SET value = excluded.value`,
		provider, key, value,
	)
	if err != nil {
		return fmt.Errorf("setting config: %w", err)
	}
	return nil
}

func (r *ConfigRepository) GetAll(ctx context.Context, provider string) (map[string]string, error) {
	rows, err := r.db.QueryContext(ctx,
		"SELECT key, value FROM provider_configs WHERE provider = ?", provider,
	)
	if err != nil {
		return nil, fmt.Errorf("getting all configs: %w", err)
	}
	defer rows.Close()

	result := make(map[string]string)
	for rows.Next() {
		var k, v string
		if err := rows.Scan(&k, &v); err != nil {
			return nil, fmt.Errorf("scanning config row: %w", err)
		}
		result[k] = v
	}
	return result, rows.Err()
}

func (r *ConfigRepository) DeleteByProvider(ctx context.Context, provider string) error {
	_, err := r.db.ExecContext(ctx,
		"DELETE FROM provider_configs WHERE provider = ?", provider,
	)
	if err != nil {
		return fmt.Errorf("deleting configs: %w", err)
	}
	return nil
}

func (r *ConfigRepository) GetActiveProvider(ctx context.Context) (string, error) {
	var value string
	err := r.db.QueryRowContext(ctx,
		"SELECT value FROM app_settings WHERE key = 'active_provider'",
	).Scan(&value)
	if err != nil {
		if err == sql.ErrNoRows {
			return "", nil
		}
		return "", fmt.Errorf("getting active provider: %w", err)
	}
	return value, nil
}

func (r *ConfigRepository) SetActiveProvider(ctx context.Context, provider string) error {
	_, err := r.db.ExecContext(ctx,
		`INSERT INTO app_settings (key, value) VALUES ('active_provider', ?)
		 ON CONFLICT(key) DO UPDATE SET value = excluded.value`,
		provider,
	)
	if err != nil {
		return fmt.Errorf("setting active provider: %w", err)
	}
	return nil
}
