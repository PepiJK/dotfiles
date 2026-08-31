---
name: pepi-worktree
description: Use when starting isolated feature work or before implementation plans; creates and verifies a Git worktree, restores project dependencies with toolchain-aware setup, and verifies with a clean production build without running tests.
---

# Using Git worktrees

## Purpose

Use an isolated workspace for feature work. Prefer a native worktree operation when
the harness provides one; otherwise use Git. A worktree contains tracked files only,
so ignored dependency directories must be restored or explicitly seeded.

**Announce at start:** "I'm using the pepi-worktree skill to set up an isolated workspace."

Verification requires dependency installation and a clean production build. Test execution is intentionally skipped.

## Step 0: Detect isolation

Record the process working directory as `<command-cwd>` before running Git
discovery. Then run:

```text
git rev-parse --show-toplevel
git rev-parse --path-format=absolute --git-dir
git rev-parse --path-format=absolute --git-common-dir
git branch --show-current
git rev-parse --show-superproject-working-tree
git status --short
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

Report dirty files. Never stash, reset, or delete existing changes. A new worktree
starts from committed history and excludes uncommitted files.

## Step 1: Create the isolated workspace

There are two mechanisms. Try them in this order.

### Select base and branch

For a new branch, always ask for the base even when a base was suggested. Offer
local `main`, local `master`, the current branch at committed `HEAD`, and a custom
local ref. Validate a custom base before changing the filesystem:

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
worktree operation. It may be exposed as a tool or command such as `EnterWorktree`,
`WorktreeCreate`, `/worktree`, or a `--worktree` flag.

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

If `git worktree add` fails because the sandbox denies the operation, report that
the sandbox blocked worktree creation and continue in the current checkout
instead. Do not silently fall back for other errors.

## Step 2: Detect the project profile and set it up

Inspect manifests before running expensive commands. If several solutions or
package roots exist, select the root solution/package that matches the repository
name. If no unique primary solution exists, report the candidates and ask before
building an expensive or unrelated solution.

### Node.js and Angular

Detect every `package.json`, its lockfile, and its install script. If a package is
a wrapper whose install script delegates to a child package, run the wrapper once
and do not run the child a second time. Otherwise use `npm ci` when a lockfile is
present and `npm install` only when no lockfile or a repository script requires it.
Report any tracked lockfile changes produced by setup; never silently discard them.

For Angular/Node.js frontend projects:
```text
npm run build -- --configuration production
```
(or standard `npm run build` / production build script defined in `package.json`).

### Modern .NET

Use `dotnet restore` and `dotnet build -c Release` only for SDK-style projects detected by
`Sdk` or `TargetFramework` project properties.

### Legacy .NET Framework

Detect `packages.config`, `TargetFrameworkVersion`, classic project XML, or
`Microsoft.WebApplication.targets` imports. These projects require Visual Studio
MSBuild, not the .NET SDK's MSBuild.

Resolve Visual Studio without requiring `vswhere.exe` or a permanent `PATH` change,
in this order:

1. An explicit `VS_MSBUILD` or `VSINSTALLDIR` environment variable.
2. `vswhere.exe` from `PATH`.
3. The Visual Studio Installer `vswhere.exe` in standard installer locations.
4. A bounded search of `Microsoft Visual Studio` roots under both Program Files
   locations, plus known custom roots such as `C:\Program Files\EigeneProgramme\VS`,
   for `MSBuild.exe`.

Select an installation containing `MSBuild.exe` and the required
`Microsoft.WebApplication.targets`. Use absolute paths or a process-local
`PATH` update. Do not permanently modify the system `PATH`. If neither MSBuild
nor the web targets exist, report that Visual Studio/Build Tools with ASP.NET web
build tools and the required .NET Framework targeting packs must be installed.

Restore and build the selected solution with Visual Studio MSBuild in Release configuration:

```text
MSBuild.exe <solution> /t:Restore /p:RestorePackagesConfig=true
MSBuild.exe <solution> /m /t:Build /p:Configuration=Release /p:Platform="Any CPU"
```

Worktrees do not contain ignored `packages`, `node_modules`, `bin`, or `obj`
directories. Restore them in the new worktree. If package restore cannot run but a
trusted sibling checkout has a cache, explicitly seed only ignored dependency
directories (copy or a read-only directory junction), verify the required package
files, and report that the cache is shared or copied. Never copy tracked source
files or assume a cache is complete because its directory count looks plausible.

Setup is complete only when the selected dependency setup and production build commands pass.
Stop and report setup errors.

## Step 3: Report and hand off

Report these statuses separately:

```text
Worktree: created/reused and verified
Dependencies: restored/setup command and result
Build: clean production build command and result
Tests: skipped (dependency install and clean prod build sufficient)
```

For a newly created worktree, provide and copy the handoff command only when the
worktree, dependency setup, and production build pass:

```text
/cwd <absolute-path>
```

On Windows PowerShell, copy it with:

```powershell
Set-Clipboard -Value '/cwd <absolute-path>'
```

If clipboard copying fails, leave the command visible. If any required local
check is blocked or inconclusive, report the worktree path and the exact blocker
but do not claim it is ready.
