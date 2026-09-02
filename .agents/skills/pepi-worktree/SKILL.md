---
name: pepi-worktree
description: Use when starting work that should be isolated in a Git worktree; creates or reuses a worktree and prepares it for development.
---

# Using Git worktrees

## Purpose

Use an isolated workspace for feature work. Prefer a native worktree operation when
the harness provides one; otherwise use Git. Prepare the new workspace using the
repository's own instructions, manifests, lockfiles, and scripts.

## Step 0: Detect isolation

Record the process working directory as `<command-cwd>` before running Git
discovery. Then run:

```text
git rev-parse --show-toplevel
git rev-parse --path-format=absolute --git-dir
git rev-parse --path-format=absolute --git-common-dir
git branch --show-current
git rev-parse --show-superproject-working-tree
```

Use the absolute paths emitted by `--path-format=absolute` for the isolation
comparison. If that option is unavailable, resolve a relative `--git-dir` or
`--git-common-dir` against `<command-cwd>`, the directory from which that Git
command was run. Never resolve those paths against `<repo-root>` unless the
command itself was run with `git -C <repo-root>`. Canonicalize path separators
and compare case-insensitively on Windows. Anchor later repository-root
operations with `git -C <repo-root>`; the current directory may be several
levels below the project root.

If `--show-superproject-working-tree` returns a path, treat the checkout as a
normal repository even when Git directories differ. Otherwise, when normalized
`GIT_DIR != GIT_COMMON_DIR`, report:

```text
Already in isolated workspace at <path> on branch <name>.
```

For detached HEAD, report that it is externally managed. Do not create another
worktree; continue with Step 2.

When `GIT_DIR == GIT_COMMON_DIR`, the checkout is normal.

If the user invoked this skill or explicitly requested an isolated worktree, treat
that as consent. If they explicitly require working in place, honor it and skip
Step 1. Otherwise ask for consent before creating anything:

> "Would you like me to set up an isolated worktree? It protects your current branch from changes."

If the user declines, work in the current checkout and continue with Step 2.

Never stash, reset, or delete existing changes. A new worktree starts from committed
history and excludes uncommitted files. Git checks in this step are for isolation and
worktree safety only; do not perform a post-setup Git cleanliness or diff validation.

## Step 1: Create the isolated workspace

There are two mechanisms. Try them in this order.

### Select base and branch

For a new branch, use an explicitly supplied base. Otherwise ask for one, offering
local `main`, local `master`, the current branch at committed `HEAD`, and a custom
local ref. Validate the base before changing the filesystem:

```text
git rev-parse --verify "<base-ref>^{commit}"
```

Use an explicitly requested existing branch without asking for a new base. If no
new branch name was supplied, ask for the full name; never invent one. Validate it:

```text
git check-ref-format --branch <branch-name>
```

### 1a. Native worktree tools (preferred)

After the user has consented, check whether the current harness provides a native
worktree operation.

If a native operation exists, pass the selected base when supported and skip to
Step 2. Native tools own directory placement, branch creation, and cleanup. Do not
also run `git worktree add`, because that creates state the harness cannot manage.

If a native operation cannot honor an explicit base, report that limitation and
ask before using the Git fallback.

If no native operation exists, continue to Step 1b.

### 1b. Git worktree fallback

#### Choose the directory

Follow this priority order. An explicit user preference always wins.

1. Use a declared worktree directory from the user's request or current
   instructions.
2. Otherwise, use an existing project-local `.worktrees` directory.
3. Otherwise, use an existing project-local `worktrees` directory.
4. If neither exists, use `.worktrees` at the project root.

If both `.worktrees` and `worktrees` exist, use `.worktrees`. Preserve the slash
in the branch name when forming the path. For example,
`feature/141602-manual-entries` becomes
`<repo-root>\.worktrees\feature\141602-manual-entries`.

#### Verify safety and existing state

For a project-local location, verify that a child path under the selected location
is ignored before creating the worktree:

```text
git -C <repo-root> check-ignore -q -- <location>\__probe__
```

This works with both `.worktrees/` and `.worktrees` ignore patterns. If a local
worktree directory is not ignored, prefer adding the selected relative directory
pattern to Git's local `info/exclude`; this avoids dirtying the user's tracked
`.gitignore`. Only change `.gitignore` when repository policy explicitly requires
a shared ignore rule, and leave that tracked change visible and uncommitted.

Before changing the filesystem, inspect both Git and the filesystem:

```text
git -C <repo-root> worktree list --porcelain
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
git -C <repo-root> worktree add <path> <branch-name>

# New branch
git -C <repo-root> worktree add -b <branch-name> <path> <base-ref>
```

Verify the registration, path, branch, and base commit:

```text
git -C <repo-root> worktree list --porcelain
git -C <path> branch --show-current
git -C <path> rev-parse HEAD
git -C <repo-root> rev-parse "<base-ref>^{commit}"
```

Confirm that the registered path is the intended absolute path, the branch is
the requested branch, and a new branch starts at the selected base commit.
Surface command errors directly and do not claim success without these checks.

Do not use filesystem cleanliness as a handoff gate. Setup commands may update
generated files without making the workspace unusable.

If `git worktree add` fails because the sandbox denies the operation, report that
the sandbox blocked worktree creation and continue in the current checkout
instead. Do not silently fall back for other errors.

## Step 2: Prepare the workspace

Read repository instructions and inspect manifests, lockfiles, workspace definitions,
and existing setup scripts. Prefer repository-defined bootstrap commands over inferred
ecosystem commands.

Restore dependencies for every project root required by the repository or intended
work. Use the package manager selected by its lockfile or configuration. Treat
workspace members covered by a root command as already restored.

Run the repository's standard development build, compile, or equivalent readiness
command when one exists. Prefer the least expensive command that proves the workspace
is usable; skip tests unless repository setup explicitly includes them.

Run independent setup commands in parallel. Surface changed lockfiles and command
failures without discarding them. If several unrelated project roots are plausible
and setup would be expensive, present the candidates before proceeding.

## Step 3: Report and hand off

Report these statuses separately:

```text
Worktree: created/reused and verified
Dependencies: setup commands and results
Readiness: development command and result, or not applicable
```

For a newly created worktree, provide and copy the handoff command only when the
worktree is verified and every required setup and readiness command passes:

```text
/cwd <absolute-path>
```

On Windows PowerShell, copy it with:

```powershell
Set-Clipboard -Value '/cwd <absolute-path>'
```

If clipboard copying fails, leave the command visible. If any required setup or
build check is blocked or inconclusive, report the worktree path and the exact
blocker but do not claim it is ready.
