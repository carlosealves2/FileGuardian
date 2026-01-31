# ADR-005: Storage Provider Abstraction

## Status
Accepted

## Context
FileGuardian initially targets AWS S3 but should be extensible to other storage providers (Azure Blob, Mega, etc.) without modifying domain or service logic.

## Decision
Define a `FileStorage` interface as a driven port with multipart upload operations. A `StorageFactory` creates the appropriate adapter based on configuration. Each provider implements the `FileStorage` interface in its own adapter package.

## Consequences
- Adding a new provider requires only: new adapter + factory registration + config.
- Domain and services remain untouched when adding providers.
- All providers must support multipart-like upload semantics.
