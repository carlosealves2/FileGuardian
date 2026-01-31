# ADR-002: gRPC for Communication

## Status
Accepted

## Context
FileGuardian needs a transport layer for client-server communication. The application requires server-side streaming for real-time upload progress.

## Decision
Use gRPC with Protocol Buffers as the sole communication protocol. Server-side streaming RPCs provide real-time upload progress updates.

## Consequences
- Strongly typed contracts via `.proto` files.
- Native streaming support for progress updates.
- Requires gRPC-compatible clients (no REST).
- Protobuf files serve as living documentation.
