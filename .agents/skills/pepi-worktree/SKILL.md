---
name: pepi-worktree
description: Use when starting feature work that needs isolation from the current workspace or before executing implementation plans; ensures an isolated workspace via native tools or a Git worktree fallback.
---

# Using Git worktrees

## Overview

Ensure work happens in an isolated workspace. Prefer the platform's native worktree
tools. Fall back to a manual Git worktree only when no native tool is available.

**Core principle:** Detect existing isolation first. Then use native tools. Then
fall back to Git. Never fight the harness.

**Announce at start:** "I'm using the pepi-worktree skill to set up an isolated workspace."

## Step 0: Detect existing isolation

**Before creating anything, check whether you are already in an isolated workspace.**

Run:

```text
git rev-parse --show-toplevel
git rev-parse --git-dir
git rev-parse --git-common-dir
git branch --show-current
git rev-parse --show-superproject-working-tree
```

Resolve `--git-dir` and `--git-common-dir` to normalized absolute paths before
comparing them. The `--show-superproject-working-tree` command returns a path
when the current repository is a Git submodule.

**Submodule guard:** A different `GIT_DIR` and `GIT_COMMON_DIR` can also occur
inside a submodule. If `git rev-parse --show-superproject-working-tree` returns a
path, treat the checkout as a normal repository, not as an already-isolated
worktree.

**If `GIT_DIR != GIT_COMMON_DIR` and the checkout is not a submodule:** You are
already in a linked worktree. Skip to Step 2. Do not create another worktree.

Report the branch state:

- On a branch: "Already in isolated workspace at `<path>` on branch `<name>`."
- Detached HEAD: "Already in isolated workspace at `<path>` (detached HEAD,
  externally managed)."

**If `GIT_DIR == GIT_COMMON_DIR` or you are in a submodule:** You are in a normal
repository checkout.

If the user or current instructions already require an isolated worktree, treat
that as consent. If they explicitly require working in place, honor it and skip
Step 1. Otherwise ask for consent before creating anything:

> "Would you like me to set up an isolated worktree? It protects your current branch from changes."

If the user declines, work in the current checkout and skip to Step 2.

Do not stash, reset, or delete existing changes. If the current checkout is dirty,
make clear that a new worktree starts from committed `HEAD` and does not include
uncommitted changes from the current checkout.

## Step 1: Create the isolated workspace

There are two mechanisms. Try them in this order.

### 1a. Native worktree tools (preferred)

After the user has consented, check whether the current harness provides a native
worktree operation. It may be exposed as a tool or command such as `EnterWorktree`,
`WorktreeCreate`, `/worktree`, or a `--worktree` flag.

If a native operation exists, use it and skip to Step 2. Native tools own
directory placement, branch creation, and cleanup. Do not also run
`git worktree add`, because that creates state the harness cannot manage.

If no native operation exists, continue to Step 1b.

### 1b. Git worktree fallback

#### Choose the branch name

Use an explicit branch name from the user's request or current instructions.
If none is available, ask for the full branch name instead of inventing one.
Validate it before creating anything:

```text
git check-ref-format --branch <branch-name>
```

#### Choose the directory

Follow this priority order. An explicit user preference always wins.

1. Use a declared worktree directory from the user's request or current
   instructions.
2. Otherwise, use an existing project-local `.worktrees` directory.
3. Otherwise, use an existing project-local `worktrees` directory.
4. If neither exists, use `.worktrees` at the project root.

If both `.worktrees` and `worktrees` exist, use `.worktrees`. Preserve the slash
in the branch name when forming the path, so
`feat/123-add-login` becomes `<location>/feat/123-add-login`.

#### Verify safety and existing state

For a project-local location, verify that the chosen directory is ignored before
creating the worktree:

```text
git check-ignore -q -- .worktrees
```

Use the selected directory instead of `.worktrees` when applicable. If it is not
ignored, add the directory pattern to `.gitignore` before proceeding. Leave that
change visible and uncommitted; never stage or commit it automatically. If
repository policy does not allow this change, stop rather than creating an
unignored worktree.

Before changing the filesystem, inspect both Git and the filesystem:

```text
git worktree list --porcelain
```

- If the exact path is already registered for the requested branch, report it as
  already present and skip creation.
- If the exact path is registered for a different branch, report an error and
  leave it unchanged.
- If the path exists but is not registered, report an error and leave it
  unchanged.
- If the branch is already checked out in another worktree, report an error and
  leave both worktrees unchanged.

#### Create and verify the worktree

Create missing parent directories with the platform-native directory command,
then run the appropriate form of:

```text
# Existing local branch
git worktree add <path> <branch-name>

# New branch from the current committed HEAD
git worktree add -b <branch-name> <path>
```

Verify both the registration and the branch:

```text
git worktree list --porcelain
git -C <path> branch --show-current
```

Confirm that the registered path is the intended absolute path and that the
branch is the requested branch. Surface command errors directly and do not claim
success without both verification checks.

If `git worktree add` fails because the sandbox denies the operation, report that
the sandbox blocked worktree creation and continue in the current checkout
instead. Do not silently fall back for other errors.

## Step 2: Project setup

From the isolated workspace (or the current checkout when isolation was declined
or blocked), run only the setup commands that match the repository. Use the
platform-native equivalent for file detection and command syntax.

| Project | Detect | Setup |
| --- | --- | --- |
| Node.js | `package.json` | `npm install` |
| Rust | `Cargo.toml` | `cargo build` |
| Python | `requirements.txt` | `pip install -r requirements.txt` |
| Python | `pyproject.toml` | `poetry install` |
| Go | `go.mod` | `go mod download` |
| .NET | `.sln`, `.slnx`, or `.csproj` | `dotnet build` |

For .NET repositories with a solution, build the solution rather than each
project separately. `dotnet build` may restore dependencies as part of the
build. Stop on setup errors, report the command output, and do not claim the
workspace is ready.

## Step 3: Verify a clean baseline

Run the applicable test commands from the isolated workspace:

| Project | Test command |
| --- | --- |
| Node.js | `npm test` |
| Rust | `cargo test` |
| Python | `pytest` |
| Go | `go test ./...` |
| .NET | `dotnet test` |

Use the repository's documented test command when one exists. Run `dotnet test`
against the solution when one is present. Do not invent test counts; report the
actual commands and results.

If tests fail, report the failures and ask whether to investigate them or
continue. If all applicable checks pass, report:

```text
Worktree ready at <absolute-path>
Baseline checks passing: <commands and results>
Ready to implement <feature-name>
```

## Quick reference

| Situation | Action |
| --- | --- |
| Already in a linked worktree | Skip creation and continue with project setup |
| In a submodule | Treat it as a normal repository checkout |
| Native worktree tool available | Use it and let the harness manage the worktree |
| No native tool | Use the Git worktree fallback |
| `.worktrees` exists | Use it after verifying it is ignored |
| `worktrees` exists | Use it after verifying it is ignored |
| Both directories exist | Use `.worktrees` |
| Neither directory exists | Default to `.worktrees` and verify or add its ignore rule |
| Directory is not ignored | Add its ignore rule, leave it uncommitted, and never auto-commit |
| Path is registered for another branch | Report the conflict and leave it unchanged |
| Path exists but is unregistered | Report the conflict and leave it unchanged |
| Permission error during creation | Report the sandbox denial and work in place |
| Baseline tests fail | Report failures and ask whether to proceed |
| .NET project is present | Run both `dotnet build` and `dotnet test` |
| No recognized project files | Skip dependency installation and project checks |

## Common rationalizations

| Excuse | Reality |
| --- | --- |
| "I'm obviously not in a worktree." | Run Step 0. Harness-created isolation and submodules can fool visual inspection. |
| "`git worktree add` is quicker than checking for native tooling." | Native tooling owns placement, branching, and cleanup. Bypassing it creates unmanaged state. |
| "The worktree directory is surely ignored already." | Run `git check-ignore` before creating project-local worktrees. |
| "Any branch name will do." | Use an explicit, validated branch name; ask instead of guessing. |
| "The workspace is fresh, so baseline tests can wait." | A failing baseline makes later failures ambiguous. Run the checks first. |
| "A successful build means the .NET baseline is clean." | Run both `dotnet build` and `dotnet test`. |
| "I can commit the ignore rule while I'm here." | This skill never stages or commits automatically. |
