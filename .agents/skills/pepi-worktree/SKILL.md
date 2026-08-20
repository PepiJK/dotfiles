---
name: pepi-worktree
description: Creates a sibling Git worktree under ../worktrees/<project>/<branch> from a GitHub Issue or Azure DevOps work item.
disable-model-invocation: true
---

# Create a Git worktree

Create a separate worktree for the current repository without changing or deleting the current checkout.

## Resolve the branch name

1. Confirm the current directory is inside a Git repository and get its root with `git rev-parse --show-toplevel`.
2. Find exactly one explicit task reference in the current request or conversation:
   - GitHub Issue URL, `owner/repository#123`, or an unambiguous issue number. Retrieve its canonical number and title with `gh issue view`.
   - Azure DevOps work item URL or explicit item ID. Retrieve its canonical ID and title with the configured Azure DevOps integration or `az boards work-item show`.
3. Derive `type` from the task intent. Use `feat` for new behavior, `fix` for bugs, `docs` for documentation, `refactor` for code restructuring, `test` for test-only work, and `chore` for maintenance. Use the item's labels or type when available.
4. Convert the title to a short English kebab-case slug. Remove the issue marker, punctuation, duplicate hyphens, and trailing hyphens.
5. Form the branch as `<type>/<id>-<english-title>`, for example `feat/123-add-login`.
6. If there is no single usable task reference, ask the user for the full branch name instead of inventing one. Validate a supplied name with `git check-ref-format --branch`.

## Create and verify the worktree

1. Set `project` to the repository root directory name and place the worktree at:
   `../worktrees/<project>/<branch>`.
   Preserve the slash in the branch name, so `feat/123-add-login` becomes `../worktrees/<project>/feat/123-add-login`.
2. Check `git worktree list --porcelain` and the filesystem before changing anything:
   - If the exact path is already registered for the requested branch, report it as already present.
   - Treat an existing unregistered path or a branch already checked out elsewhere as an error. Leave both unchanged.
3. Create the parent directories with the platform-native directory command.
4. If the local branch already exists, run `git worktree add <path> <branch>`. Otherwise run `git worktree add -b <branch> <path>`.
5. Verify the new entry with `git worktree list --porcelain` and confirm its branch with `git -C <path> branch --show-current`.
6. Report the branch and absolute worktree path. Surface command errors directly and do not claim success without both verification checks.
