# FileGuardian

Desktop backup application for uploading files and folders to cloud storage with real-time progress tracking, pause/resume support, and multipart upload management.

## Features

- **File & folder upload** to cloud storage with real-time progress streaming
- **Multipart upload** with configurable part size (default 5MB)
- **Pause, resume & cancel** active uploads at any time
- **Concurrent uploads** at both file and part level
- **Storage provider abstraction** supporting AWS S3 and S3-compatible endpoints, extensible to other providers
- **Secure credential storage** using the OS keychain (macOS Keychain, Windows Credential Manager, Linux Secret Service)
- **Process tracking** with status state machine (pending, in progress, paused, completed, failed, cancelled)
- **Dashboard** with upload statistics, process list, and backup tracking
- **System tray** integration for background operation
- **Desktop notifications** for key events
- **Light & dark theme** with Material 3

## Architecture

The project follows **Hexagonal Architecture (Ports & Adapters)** on the backend and **Clean Architecture** on the frontend. Communication between the Go backend and Flutter desktop app is handled exclusively via **gRPC** with Protocol Buffers, using server-side streaming for real-time progress updates.

```
file-guardian/
├── cmd/fileguardian/          # Application entry point
├── internal/
│   ├── domain/                # Entities, value objects, business rules
│   ├── ports/                 # Driving and driven interfaces
│   ├── app/service/           # Application services
│   ├── adapters/
│   │   ├── driving/grpc/      # gRPC handlers (inbound)
│   │   └── driven/            # Repository, storage, secrets (outbound)
│   ├── config/                # Environment configuration
│   └── tray/                  # System tray integration
├── proto/fileguardian/v1/     # Protobuf service definitions
├── guardian_ui/               # Flutter desktop application
│   └── lib/
│       ├── core/              # DI, router, theme, gRPC client
│       └── features/          # Feature modules (Clean Architecture)
├── docs/adr/                  # Architecture Decision Records
├── Makefile                   # Build automation
└── Dockerfile                 # Multi-stage Docker build
```

## Tech Stack

### Backend

- **Go** 1.25 — application logic and gRPC server
- **gRPC + Protocol Buffers** — API contracts and streaming
- **SQLite** (CGO-free via `modernc.org/sqlite`) — persistence with WAL mode
- **AWS S3 SDK v2** — cloud storage (extensible via `FileStorage` interface)
- **go-keyring** — OS keychain integration for secrets
- **systray** — system tray with background operation
- **Buf** — protobuf linting and code generation

### Frontend

- **Flutter** (Dart 3.10) — cross-platform desktop UI (macOS, Linux, Windows)
- **flutter_bloc** — state management
- **go_router** — declarative navigation
- **get_it + injectable** — dependency injection
- **fpdart** — functional error handling with `Either`
- **freezed** — immutable data classes and sealed states
- **gRPC Dart** — backend communication

## Prerequisites

- **Go** 1.25.6+
- **Flutter** 3.10.4+
- **Buf** (latest)
- **protoc** with Dart plugin (for Flutter proto generation)

## Getting Started

1. Clone the repository and copy the environment file:

```bash
git clone https://github.com/carlosealves2/FileGuardian.git
cd FileGuardian
cp .env.example .env
```

2. Generate protobuf code:

```bash
make proto-all
```

3. Generate Flutter code (freezed, injectable):

```bash
make ui-gen
```

4. Start the backend:

```bash
make run
```

5. Start the Flutter app (in a separate terminal):

```bash
make ui-run
```

The backend starts a gRPC server on port `50051` with a system tray icon. The Flutter app connects to it automatically.

## Configuration

Environment variables (via `.env` file):

| Variable | Default | Description |
|---|---|---|
| `GRPC_PORT` | `50051` | gRPC server port |
| `UPLOAD_PART_SIZE` | `5242880` | Multipart upload part size in bytes (5MB) |
| `UPLOAD_MAX_CONCURRENT` | `5` | Max concurrent file uploads |
| `DB_PATH` | `~/.file-guardian/fileguardian.db` | SQLite database path |
| `LOCK_PATH` | `~/.file-guardian/lock` | Single instance lock file path |

Storage provider credentials (S3 access key, secret key, bucket, region) are configured through the Settings screen in the Flutter app and stored securely in the OS keychain.

## Makefile Commands

### Backend

| Command | Description |
|---|---|
| `make build` | Build Go binary to `bin/fileguardian` |
| `make run` | Build and run the backend |
| `make test` | Run Go tests with race detector |
| `make test-cover` | Generate test coverage report |
| `make proto` | Generate Go code from `.proto` files |
| `make lint` | Lint proto files and Go code |
| `make clean` | Remove build artifacts |

### Frontend

| Command | Description |
|---|---|
| `make ui-run` | Run Flutter app on macOS |
| `make ui-test` | Run Flutter tests |
| `make ui-build` | Build macOS app bundle |
| `make ui-gen` | Generate freezed/injectable code |
| `make ui-clean` | Clean Flutter build artifacts |
| `make proto-dart` | Generate Dart code from `.proto` files |

### Combined

| Command | Description |
|---|---|
| `make proto-all` | Generate Go + Dart proto code |
| `make test-all` | Run all tests (Go + Flutter) |
| `make clean-all` | Clean all build artifacts |

## Docker

```bash
docker build -t fileguardian .
docker run -p 50051:50051 -v ~/.file-guardian:/root/.file-guardian fileguardian
```

## gRPC API

Defined in `proto/fileguardian/v1/`:

**UploadService** — file and folder uploads with streaming progress, pause/resume/cancel, process listing and detail.

**ConfigService** — application configuration, storage provider listing and configuration with dynamic field schemas.

## Architecture Decision Records

| ADR | Decision |
|---|---|
| [001](docs/adr/001-hexagonal-architecture.md) | Hexagonal Architecture |
| [002](docs/adr/002-grpc-communication.md) | gRPC Communication |
| [003](docs/adr/003-sqlite-persistence.md) | SQLite Persistence |
| [004](docs/adr/004-multipart-upload-pause-resume.md) | Multipart Upload with Pause/Resume |
| [005](docs/adr/005-storage-provider-abstraction.md) | Storage Provider Abstraction |
| [006](docs/adr/006-flutter-desktop-frontend.md) | Flutter Desktop Frontend |

## License

This project is for personal use.
