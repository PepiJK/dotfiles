---
name: verify
description: Run all formatting, linting, test, and build tools in the current repo and give a summary.
---

# Instructions

When invoked, you must:
1. Identify the project type and tools used in the current repository (e.g., looking for package.json, Makefile, go.mod, Cargo.toml).
2. Run the appropriate commands for:
   - Code formatting (e.g., `npm run format`, `gofmt`, `cargo fmt`, `black`)
   - Code linting (e.g., `npm run lint`, `golangci-lint`, `cargo clippy`, `flake8`)
   - Running tests (e.g., `npm test`, `go test`, `cargo test`, `pytest`)
   - Building the project (e.g., `npm run build`, `go build`, `cargo build`)
3. Capture the output of these tools.
4. Provide a clear summary at the end, detailing which steps passed or failed, and any warnings or errors that need attention.
