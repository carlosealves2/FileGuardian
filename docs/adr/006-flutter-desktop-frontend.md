# ADR-006: Flutter Desktop Frontend

## Status

Accepted

## Context

FileGuardian needs a desktop GUI to allow users to upload files/folders, monitor progress in real time, and configure storage providers. The backend exposes a gRPC API with server-side streaming for upload progress.

Requirements:
- Desktop-native experience (macOS, Linux, Windows).
- Real-time upload progress via gRPC streaming.
- Pause, resume, and cancel uploads.
- Dynamic provider configuration forms.
- Light and dark theme support.

Alternatives considered:
- **React + Electron**: Cross-platform but heavy runtime (~150MB+), duplicates Chromium. Overkill for this use case.
- **Wails (Go + Web)**: Lighter than Electron but limited desktop widget toolkit. gRPC client support in JS is less mature.
- **Native (SwiftUI / GTK)**: Best performance per platform but requires maintaining separate codebases.

## Decision

Use **Flutter** as the desktop frontend framework with:
- **flutter_bloc** for state management (clear separation of UI and business logic).
- **gRPC Dart** for communication with the backend (same `.proto` contracts).
- **Clean Architecture** with feature-based folder structure.
- **GoRouter** for declarative routing with sidebar navigation.
- **Material 3** with light/dark theme support.
- **get_it** for dependency injection.
- **fpdart** (Either) for typed error handling.

## Consequences

### Positive
- Single codebase compiles for macOS, Linux, and Windows.
- Dart gRPC client generates stubs from the same `.proto` files, ensuring contract consistency.
- Server-side streaming maps naturally to Dart Streams and Bloc pattern.
- Flutter's hot reload enables fast UI iteration.
- Clean Architecture ensures the UI layer is decoupled from gRPC details.

### Negative
- Flutter desktop is less mature than mobile — some platform-specific behaviors may require workarounds.
- Dart gRPC ecosystem is smaller than Go's, though sufficient for client-side usage.
- Additional build toolchain (Flutter SDK + protoc Dart plugin) required in development environment.

### Trade-offs
- Proto-generated Dart stubs are committed to the repository to avoid requiring `protoc` for every build. This trades repository size for build simplicity.
- Freezed-generated files (`*.freezed.dart`, `*.g.dart`) are NOT committed — they're regenerated via `make ui-gen`.
