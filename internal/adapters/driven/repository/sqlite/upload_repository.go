package sqlite

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"

	"github.com/carlosealves2/FileGuardian/internal/domain"
	"github.com/carlosealves2/FileGuardian/internal/domain/entity"
	"github.com/carlosealves2/FileGuardian/internal/domain/valueobject"
)

type UploadRepository struct {
	db *sql.DB
}

func NewUploadRepository(db *sql.DB) *UploadRepository {
	return &UploadRepository{db: db}
}

func (r *UploadRepository) Create(ctx context.Context, upload entity.Upload) error {
	partsJSON, err := json.Marshal(upload.CompletedParts)
	if err != nil {
		return fmt.Errorf("marshaling completed parts: %w", err)
	}

	_, err = r.db.ExecContext(ctx,
		`INSERT INTO uploads (id, process_id, file_path, storage_key, file_size, bytes_uploaded,
		 status, error_message, checksum, multipart_upload_id, completed_parts, created_at, updated_at)
		 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
		upload.ID, upload.ProcessID, upload.FilePath, upload.StorageKey, upload.FileSize,
		upload.BytesUploaded, upload.Status.String(), upload.ErrorMessage, upload.Checksum,
		upload.MultipartUploadID, string(partsJSON), upload.CreatedAt, upload.UpdatedAt,
	)
	if err != nil {
		return fmt.Errorf("inserting upload: %w", err)
	}
	return nil
}

func (r *UploadRepository) GetByID(ctx context.Context, id string) (entity.Upload, error) {
	row := r.db.QueryRowContext(ctx,
		`SELECT id, process_id, file_path, storage_key, file_size, bytes_uploaded,
		 status, error_message, checksum, multipart_upload_id, completed_parts,
		 created_at, updated_at FROM uploads WHERE id = ?`, id)

	return scanUpload(row)
}

func (r *UploadRepository) Update(ctx context.Context, upload entity.Upload) error {
	partsJSON, err := json.Marshal(upload.CompletedParts)
	if err != nil {
		return fmt.Errorf("marshaling completed parts: %w", err)
	}

	result, err := r.db.ExecContext(ctx,
		`UPDATE uploads SET file_path = ?, storage_key = ?, file_size = ?, bytes_uploaded = ?,
		 status = ?, error_message = ?, checksum = ?, multipart_upload_id = ?,
		 completed_parts = ?, updated_at = ? WHERE id = ?`,
		upload.FilePath, upload.StorageKey, upload.FileSize, upload.BytesUploaded,
		upload.Status.String(), upload.ErrorMessage, upload.Checksum,
		upload.MultipartUploadID, string(partsJSON), upload.UpdatedAt, upload.ID,
	)
	if err != nil {
		return fmt.Errorf("updating upload: %w", err)
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

func (r *UploadRepository) ListByProcessID(ctx context.Context, processID string) ([]entity.Upload, error) {
	rows, err := r.db.QueryContext(ctx,
		`SELECT id, process_id, file_path, storage_key, file_size, bytes_uploaded,
		 status, error_message, checksum, multipart_upload_id, completed_parts,
		 created_at, updated_at FROM uploads WHERE process_id = ? ORDER BY created_at ASC`, processID)
	if err != nil {
		return nil, fmt.Errorf("listing uploads: %w", err)
	}
	defer rows.Close()

	var uploads []entity.Upload
	for rows.Next() {
		u, scanErr := scanUploadRows(rows)
		if scanErr != nil {
			return nil, scanErr
		}
		uploads = append(uploads, u)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iterating uploads: %w", err)
	}

	return uploads, nil
}

func scanUpload(row *sql.Row) (entity.Upload, error) {
	var u entity.Upload
	var statusStr, partsJSON string

	if err := row.Scan(
		&u.ID, &u.ProcessID, &u.FilePath, &u.StorageKey, &u.FileSize,
		&u.BytesUploaded, &statusStr, &u.ErrorMessage, &u.Checksum,
		&u.MultipartUploadID, &partsJSON, &u.CreatedAt, &u.UpdatedAt,
	); err != nil {
		if err == sql.ErrNoRows {
			return entity.Upload{}, domain.ErrNotFound
		}
		return entity.Upload{}, fmt.Errorf("scanning upload: %w", err)
	}

	s, err := valueobject.ParseStatus(statusStr)
	if err != nil {
		return entity.Upload{}, err
	}
	u.Status = s

	if err := json.Unmarshal([]byte(partsJSON), &u.CompletedParts); err != nil {
		return entity.Upload{}, fmt.Errorf("unmarshaling completed parts: %w", err)
	}

	return u, nil
}

func scanUploadRows(rows *sql.Rows) (entity.Upload, error) {
	var u entity.Upload
	var statusStr, partsJSON string

	if err := rows.Scan(
		&u.ID, &u.ProcessID, &u.FilePath, &u.StorageKey, &u.FileSize,
		&u.BytesUploaded, &statusStr, &u.ErrorMessage, &u.Checksum,
		&u.MultipartUploadID, &partsJSON, &u.CreatedAt, &u.UpdatedAt,
	); err != nil {
		return entity.Upload{}, fmt.Errorf("scanning upload row: %w", err)
	}

	s, err := valueobject.ParseStatus(statusStr)
	if err != nil {
		return entity.Upload{}, err
	}
	u.Status = s

	if err := json.Unmarshal([]byte(partsJSON), &u.CompletedParts); err != nil {
		return entity.Upload{}, fmt.Errorf("unmarshaling completed parts: %w", err)
	}

	return u, nil
}
