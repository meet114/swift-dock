# Swiftdock

A native macOS container runtime and management tool.

## Philosophy

- **Mac-First**: Designed for macOS, using native APIs where possible.
- **Clean Architecture**: Clear separation between daemon, CLI, and clients.
- **Open Source**: MIT Licensed and community driven.

## Structure

- `apps/`: Application entry points (CLI, Daemon, GUI clients).
- `packages/`: Core logic libraries.
- `docs/`: Project documentation.

## Getting Started

### Prerequisites
- macOS 14.0 or later (Apple Silicon recommended for native performance)
- Swift 5.9+

### Running Swiftdock

Swiftdock consists of a **Daemon** (`swiftdockd`) and a **CLI** (`swiftdock`).

1. **Start the Daemon**
   Open a terminal, navigate to the package directory, and run the daemon service.
   ```bash
   cd swiftdock
   swift run swiftdockd
   ```
   *The daemon listens on `http://localhost:8080`. Keep this window open.*

2. **Use the CLI**
   In a **new** terminal window, use the `swiftdock` command to interact with the daemon.

   **Pull an image:**
   ```bash
   swift run swiftdock pull alpine:latest
   ```

   **Run a container:**
   ```bash
   swift run swiftdock run alpine:latest -- echo "Hello from Swiftdock"
   ```

   **List running/exited containers:**
   ```bash
   swift run swiftdock ps
   ```

   **View logs:**
   ```bash
   swift run swiftdock logs <CONTAINER_ID>
   ```

## Development
- **Build**: `swift build`
- **Test**: `swift test`

