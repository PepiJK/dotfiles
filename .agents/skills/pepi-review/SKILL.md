---
name: pepi-review
description: Read-only review of all staged, unstaged, and untracked changes across any technology stack.
---

# Instructions

1. Determine the complete scope:
   - Run `git status --short`.
   - Run `git diff --name-status HEAD`.
   - Run `git diff HEAD`.
   - Run `git ls-files --others --exclude-standard`.
   - Include untracked files; `git diff HEAD` does not show them.

2. Discover repository requirements:
   - Read applicable `AGENTS.md`, `CONTRIBUTING.md`, `README.md`, architecture documents, and feature documentation.
   - Detect the languages, frameworks, project structure, and available validation commands.
   - Never assume frontend, backend, framework, architecture, or naming conventions.

3. Understand the complete change:
   - Read complete changed files, not only diff hunks.
   - Inspect direct callers, consumers, contracts, implementations, tests, configuration, and documentation.
   - Compare with analogous repository implementations.
   - Search for existing equivalents before accepting new helpers, types, constants, or abstractions.

4. Review correctness:
   - Logic errors and behavioral regressions.
   - Missing boundary, empty, null, failure, cancellation, and concurrency handling.
   - Incorrect state or resource lifecycle.
   - Incomplete refactors and stale references.
   - Contract, API, schema, serialization, or compatibility problems.
   - Debug code, temporary workarounds, secrets, and unsafe data exposure.

5. Review architecture and maintainability:
   - Enforce the repository’s documented dependency direction and module responsibilities.
   - Ensure code is placed at the narrowest appropriate shared scope.
   - Identify misplaced business logic, pure logic, infrastructure logic, or state ownership.
   - Find semantic duplication, including differently named equivalent implementations.
   - Review unnecessary exports, abstractions, mutable APIs, dead code, and avoidable complexity.

6. Review completeness:
   - Check every implementation of changed contracts.
   - Check mocks, fixtures, migrations, configuration, and generated boundaries where relevant.
   - Ensure tests cover changed behavior and important regression scenarios.
   - Ensure documentation matches the final behavior.

7. Validate without modifying files:
   - Run `git diff --check`.
   - Discover targeted validation commands from the repository.
   - Run appropriate non-fixing tests, linting, type checks, or builds when justified.
   - Never use formatting writes or `--fix`.
   - Avoid repo-wide release gates unless requested or required by repository instructions.

8. Report findings first:
   - Order by Blocker, High, Medium, and Low.
   - Include `path:line`, impact, triggering scenario, and recommended correction.
   - Report only evidence-based, actionable findings.
   - Separate defects, optional improvements, pre-existing issues, and validation gaps.
   - If no findings exist, state that explicitly.

9. Review the current final state:
   - Recalculate the scope from scratch after fixes.
   - Do not assume that fixing earlier findings introduced no regressions.
   - Do not declare commit readiness without reviewing the resulting diff and completing required validation.

# Constraints

- Do not create, edit, delete, stage, or commit files.
- Do not impose personal style preferences unsupported by repository rules.
- Do not claim a comprehensive security audit.
