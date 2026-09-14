---
name: pepi-verify
description: Runs the repository's formatting, linting, test, and build checks and summarizes the results. Use when asked to verify, validate, test, lint, format, or build the repository.
disable-model-invocation: true
---

# Instructions

When invoked, you must:
1. Identify the project type and tools used in the current repository (e.g., looking for package.json, Makefile, go.mod, Cargo.toml).
2. Run the appropriate commands for:
   - Code formatting (e.g., `npm run format`, `npx prettier`, `dotnet format`)
   - Code linting (e.g., `npm run lint`, `npx eslint`)
   - Running tests (e.g., `npm test`, `dotnet test`)
   - Building the project (e.g., `npm run build`, `dotnet build`)
3. Capture the output of these tools.
4. Provide a clear summary at the end, detailing which steps passed or failed, and any warnings or errors that need attention.
