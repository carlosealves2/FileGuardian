# ADR-003: SQLite for Persistence

## Status
Accepted

## Context
FileGuardian needs local persistence for upload processes and their state (including multipart upload IDs for pause/resume). The application runs as a single-user desktop app.

## Decision
Use SQLite via `modernc.org/sqlite` (CGO-free pure Go driver) for local persistence. Schema changes are managed via versioned migration files.

## Consequences
- Zero external database dependency; embedded in the binary.
- CGO-free enables simple cross-compilation.
- Single-writer limitation is acceptable for a single-user desktop app.
- Multipart upload state (upload ID, completed parts) is persisted for resume capability.
