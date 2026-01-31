# ADR-004: Multipart Upload for Pause/Resume

## Status
Accepted

## Context
FileGuardian must support pausing and resuming large file uploads without re-uploading already transferred data.

## Decision
Use multipart upload as the core upload mechanism. Each file is split into parts (default 5MB). The multipart upload ID and completed parts are persisted in SQLite after each part completes. On pause, the current part finishes and state is saved. On resume, upload continues from the next incomplete part. On cancel, the multipart upload is aborted on the storage provider.

## Consequences
- Pause/resume works reliably via persisted state.
- Each part has integrity verification (ETag/checksum).
- Slightly more complex than single-shot upload.
- Storage provider must support multipart upload (S3, Azure Block Blob, etc.).
