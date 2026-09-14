---
description: Issue tracker conventions and CLI operations for GitHub and Azure DevOps
---

# Issue tracker conventions

Issues, user stories, and tasks live in the project's tracking system. Use the corresponding CLI
tool for agent interactions.

## Platform detection

Infer the platform from the repository remote (`git remote -v`):
- **GitHub**: remote matches `github.com` → use GitHub CLI (`gh`).
- **Azure DevOps**: remote matches `dev.azure.com` or `visualstudio.com` → use Azure DevOps CLI (`az boards`).

---

## GitHub conventions (`gh`)

When using GitHub Issues:

- **Create an issue**: `gh issue create --title "..." --body "..."` (use PowerShell here-string or `@file` for multi-line bodies).
- **Read an issue**: `gh issue view <number> --comments` (optionally filter with `--json title,body,labels,comments`).
- **List open issues**: `gh issue list --state open --json number,title,labels` with optional `--label` filter.
- **Comment on an issue**: `gh issue comment <number> --body "..."`.
- **Apply / remove labels**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`.
- **Close an issue**: `gh issue close <number> --comment "..."`.

### GitHub PR operations

- **Read a PR**: `gh pr view <number> --comments` and `gh pr diff <number>`.
- **Comment / close**: `gh pr comment <number> --body "..."` / `gh pr close <number>`.

---

## Azure DevOps conventions (`az boards`)

When using Azure DevOps Boards:

- **Create a work item**:
  ```powershell
  az boards work-item create --title "..." --type "Task" --description "..." # Types: Bug, Task, "User Story", Feature
  ```
- **Read a work item**:
  ```powershell
  az boards work-item show --id <id> --output json
  ```
- **Query / list work items**:
  ```powershell
  az boards query --wiql "SELECT [System.Id], [System.Title], [System.State] FROM WorkItems WHERE [System.State] = 'Active' ORDER BY [System.Id] DESC" --output table
  ```
- **Update a work item**:
  ```powershell
  az boards work-item update --id <id> --state "Active" # or "Resolved", "Closed"
  ```
- **Add comment / discussion**:
  ```powershell
  az boards work-item update --id <id> --discussion "..."
  ```

### Azure DevOps PR operations (`az repos pr`)

- **View PR**: `az repos pr show --id <id>`
- **List PRs**: `az repos pr list --status active`

---

## Common agent conventions

### When a skill says "publish to the issue tracker"

- **GitHub**: Create a GitHub issue using `gh issue create`.
- **Azure DevOps**: Create a work item using `az boards work-item create`.

### When a skill says "fetch the relevant ticket"

- **GitHub**: Run `gh issue view <number> --comments`.
- **Azure DevOps**: Run `az boards work-item show --id <id>`.

### Work item / issue referencing

- In branch names: `<type>/<id>-<title>` (e.g. `feature/123-description`, `task/141602-description`).
- In commit messages:
  - GitHub: `#<number>`, `Closes #<number>`, or `Fixes #<number>`.
  - Azure DevOps: `AB#<id>` or `Fixes AB#<id>`.
- In PR descriptions:
  - GitHub: `Closes #<number>` or `Fixes #<number>`.
  - Azure DevOps: `Fixes AB#<id>` or `AB#<id>`.
