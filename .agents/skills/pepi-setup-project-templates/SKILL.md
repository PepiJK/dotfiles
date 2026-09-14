---
name: pepi-setup-project-templates
description: Sets up standard agent templates (branch, commit, PR, issue guidance) and platform templates for GitHub or Azure DevOps in a repository.
disable-model-invocation: true
---

# Setup project templates

Set up agent workflow templates in a target repository. This skill establishes standard
guidance for branch naming, conventional commits, pull requests, issue/work item templates,
and platform-specific templates, working across GitHub and Azure DevOps.

## Process

### Step 1: Detect repository root and platform

1. Find the target repository root:
   ```powershell
   git rev-parse --show-toplevel
   ```
2. Detect the remote platform by inspecting `git remote -v`:
   - If the remote URL contains `github.com` → **GitHub**
   - If the remote URL contains `dev.azure.com` or `visualstudio.com` → **Azure DevOps**
   - If ambiguous or no remote exists, check for an existing `.github` or `.azuredevops` folder, or ask the user.

### Step 2: Choose the documentation directory

Ask the user: "Which repository-relative documentation directory should I use? Choose a detected
candidate or provide another path." Present detected candidates and accept a custom path. Include
these common choices:

- `docs/agents`
- `Docs/agents`
- another path supplied by the user

Use the selected path exactly, including its casing. Create it when it does not exist; do not
silently choose a default.

### Step 3: Copy core guidance templates

Copy the following files from the skill's `references/docs/agents/` into the selected `<doc-dir>/`:

- `branch-template.md`: Rules for issue-backed and non-issue branch naming.
- `commit-template.md`: Conventional commit structure, PowerShell syntax, and work-item linking.
- `pull-request-template.md`: Preparation steps, required headings, and completion criteria.
- `issue-template-guidance.md`: Selecting and completing bug, feature, and task templates.

Do not overwrite existing files unless explicitly instructed or run with `-Force`.

### Step 4: Copy platform templates

#### For GitHub repositories:
- Copy `references/platform/github/pull_request_template.md` to `.github/pull_request_template.md`.
- Copy `references/platform/github/ISSUE_TEMPLATE/*` to `.github/ISSUE_TEMPLATE/`:
  - `bug_report.md`
  - `feature.md`
  - `task.md`

#### For Azure DevOps repositories:
- Copy `references/platform/azuredevops/pull_request_template.md` to `.azuredevops/pull_request_template.md`.
- Copy `references/platform/azuredevops/work-item-templates/*` to `.azuredevops/work-item-templates/`:
  - `bug.md`
  - `feature.md`
  - `task.md`

After copying either platform PR template, replace its `docs/agents` prefix with the selected
`<doc-dir>` so the generated reference preserves the user's chosen casing.

### Step 5: Verify or update AGENTS.md

If `AGENTS.md` exists at the repository root, inspect it to see if workflow templates are already referenced.
If missing, offer to add or insert the following section under project boundaries or workflow:

```markdown
## Workflow templates

- Before creating a branch, read `<doc-dir>/branch-template.md`.
- Before creating a commit, read `<doc-dir>/commit-template.md`.
- Before creating an issue or work item, read `<doc-dir>/issue-template-guidance.md`.
- Before creating or updating a pull request, read `<doc-dir>/pull-request-template.md`.
```

### Step 6: Completion criteria

Setup is complete when:
- All 4 core guidance files exist in the documentation directory.
- The platform PR template exists in `.github/` or `.azuredevops/`.
- The platform issue/work-item templates exist in `.github/ISSUE_TEMPLATE/` or `.azuredevops/work-item-templates/`.
- Installed files are reported factually to the user.
