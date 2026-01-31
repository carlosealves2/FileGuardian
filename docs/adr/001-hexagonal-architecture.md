# ADR-001: Hexagonal Architecture

## Status
Accepted

## Context
FileGuardian needs a clean separation between business logic and external dependencies (gRPC, S3, SQLite, system tray). The application must be testable in isolation and extensible to support new storage providers.

## Decision
Adopt Hexagonal Architecture (Ports & Adapters). Domain and application logic are at the center, isolated from infrastructure. Communication between layers is done through interfaces (ports).

## Consequences
- Domain logic is fully testable with mocks.
- Adding new storage providers requires only a new adapter implementing the `FileStorage` interface.
- Slightly more boilerplate for interface definitions and dependency injection.
