package sqlite

import (
	"context"
	"database/sql"
	"encoding/base64"
	"fmt"
	"time"

	"github.com/carlosealves2/FileGuardian/internal/domain"
	"github.com/carlosealves2/FileGuardian/internal/domain/entity"
	"github.com/carlosealves2/FileGuardian/internal/domain/valueobject"
)

type ProcessRepository struct {
	db *sql.DB
}

func NewProcessRepository(db *sql.DB) *ProcessRepository {
	return &ProcessRepository{db: db}
}

func (r *ProcessRepository) Create(ctx context.Context, process entity.Process) error {
	_, err := r.db.ExecContext(ctx,
		`INSERT INTO processes (id, type, status, provider, source_path, created_at, updated_at)
		 VALUES (?, ?, ?, ?, ?, ?, ?)`,
		process.ID, process.Type.String(), process.Status.String(), process.Provider,
		process.SourcePath, process.CreatedAt, process.UpdatedAt,
	)
	if err != nil {
		return fmt.Errorf("inserting process: %w", err)
	}
	return nil
}

func (r *ProcessRepository) GetByID(ctx context.Context, id string) (entity.Process, error) {
	row := r.db.QueryRowContext(ctx,
		`SELECT id, type, status, provider, source_path, created_at, updated_at
		 FROM processes WHERE id = ?`, id)

	return scanProcess(row)
}

func (r *ProcessRepository) Update(ctx context.Context, process entity.Process) error {
	result, err := r.db.ExecContext(ctx,
		`UPDATE processes SET type = ?, status = ?, provider = ?, source_path = ?,
		 updated_at = ? WHERE id = ?`,
		process.Type.String(), process.Status.String(), process.Provider,
		process.SourcePath, process.UpdatedAt, process.ID,
	)
	if err != nil {
		return fmt.Errorf("updating process: %w", err)
	}

	rows, err := result.RowsAffected()
	if err != nil {
		return fmt.Errorf("checking rows affected: %w", err)
	}
	if rows == 0 {
		return domain.ErrNotFound
	}

	return nil
}

func (r *ProcessRepository) List(ctx context.Context, cursor string, limit int) ([]entity.Process, string, error) {
	if limit <= 0 {
		limit = 20
	}

	var rows *sql.Rows
	var err error

	if cursor == "" {
		rows, err = r.db.QueryContext(ctx,
			`SELECT id, type, status, provider, source_path, created_at, updated_at
			 FROM processes ORDER BY created_at DESC, id DESC LIMIT ?`, limit+1)
	} else {
		cursorTime, cursorID, decodeErr := decodeCursor(cursor)
		if decodeErr != nil {
			return nil, "", fmt.Errorf("invalid cursor: %w", decodeErr)
		}
		rows, err = r.db.QueryContext(ctx,
			`SELECT id, type, status, provider, source_path, created_at, updated_at
			 FROM processes
			 WHERE (created_at < ? OR (created_at = ? AND id < ?))
			 ORDER BY created_at DESC, id DESC LIMIT ?`,
			cursorTime, cursorTime, cursorID, limit+1)
	}
	if err != nil {
		return nil, "", fmt.Errorf("listing processes: %w", err)
	}
	defer rows.Close()

	var processes []entity.Process
	for rows.Next() {
		p, scanErr := scanProcessRows(rows)
		if scanErr != nil {
			return nil, "", scanErr
		}
		processes = append(processes, p)
	}
	if err := rows.Err(); err != nil {
		return nil, "", fmt.Errorf("iterating processes: %w", err)
	}

	var nextCursor string
	if len(processes) > limit {
		last := processes[limit-1]
		nextCursor = encodeCursor(last.CreatedAt, last.ID)
		processes = processes[:limit]
	}

	return processes, nextCursor, nil
}

func scanProcess(row *sql.Row) (entity.Process, error) {
	var p entity.Process
	var typStr, statusStr string

	if err := row.Scan(&p.ID, &typStr, &statusStr, &p.Provider, &p.SourcePath, &p.CreatedAt, &p.UpdatedAt); err != nil {
		if err == sql.ErrNoRows {
			return entity.Process{}, domain.ErrNotFound
		}
		return entity.Process{}, fmt.Errorf("scanning process: %w", err)
	}

	pt, err := valueobject.ParseProcessType(typStr)
	if err != nil {
		return entity.Process{}, err
	}
	s, err := valueobject.ParseStatus(statusStr)
	if err != nil {
		return entity.Process{}, err
	}

	p.Type = pt
	p.Status = s
	return p, nil
}

func scanProcessRows(rows *sql.Rows) (entity.Process, error) {
	var p entity.Process
	var typStr, statusStr string

	if err := rows.Scan(&p.ID, &typStr, &statusStr, &p.Provider, &p.SourcePath, &p.CreatedAt, &p.UpdatedAt); err != nil {
		return entity.Process{}, fmt.Errorf("scanning process row: %w", err)
	}

	pt, err := valueobject.ParseProcessType(typStr)
	if err != nil {
		return entity.Process{}, err
	}
	s, err := valueobject.ParseStatus(statusStr)
	if err != nil {
		return entity.Process{}, err
	}

	p.Type = pt
	p.Status = s
	return p, nil
}

func encodeCursor(t time.Time, id string) string {
	raw := fmt.Sprintf("%s|%s", t.Format(time.RFC3339Nano), id)
	return base64.StdEncoding.EncodeToString([]byte(raw))
}

func decodeCursor(cursor string) (time.Time, string, error) {
	raw, err := base64.StdEncoding.DecodeString(cursor)
	if err != nil {
		return time.Time{}, "", err
	}

	parts := splitOnce(string(raw), '|')
	if len(parts) != 2 {
		return time.Time{}, "", fmt.Errorf("malformed cursor")
	}

	t, err := time.Parse(time.RFC3339Nano, parts[0])
	if err != nil {
		return time.Time{}, "", err
	}

	return t, parts[1], nil
}

func splitOnce(s string, sep byte) []string {
	for i := range len(s) {
		if s[i] == sep {
			return []string{s[:i], s[i+1:]}
		}
	}
	return []string{s}
}
