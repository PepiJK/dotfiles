---
name: pepi-commit
description: Reviews and commits all current repository changes using a human-readable Conventional Commit, without pushing. Use only when explicitly asked to commit the current changes.
---
# Instructions
1. Run `git status --short --branch` to identify all modified, added, deleted, and untracked files. If there are no changes, report that there is nothing to commit and stop.
2. Stage all changes with `git add -A`. This skill is invoked when the user wants all current repository changes committed.
3. Inspect the exact staged snapshot that will be committed:
   - `git diff --cached --stat`
   - `git diff --cached --name-status`
   - `git diff --cached`
   - `git -c core.whitespace=blank-at-eol,blank-at-eof,space-before-tab,cr-at-eol diff --cached --check`

   The staged diff includes untracked files, unlike `git diff HEAD` run before staging. If the staged diff is empty or the CRLF-aware whitespace check reports problems, report the result and stop.
4. Generate a human-readable commit message from the staged diff:
   - Subject: `<type>(<scope>): <imperative summary>`, with an optional scope and no period. Keep it specific and under roughly 72 characters.
   - Use Conventional Commit types such as `feat`, `fix`, `refactor`, `docs`, `test`, `build`, and `chore`.
   - Body: leave a blank line after the subject, then include 2–5 concise bullets explaining the meaningful changes and their purpose. Do not write a file-by-file dump.

   Example:
   ```text
   chore(skills): remove pepi-ask references

   - Remove stale references to the deleted skill from the global instructions.
   - Stop creating links for it in the Linux and Windows setup scripts.
   - Keep the remaining skill registrations unchanged.
   ```
5. Commit the subject and body as a multiline message. Use `git commit -m "<subject>" -m "<body>"` or an appropriate message file when needed. Include this trailer:
   `Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>`
6. Verify the result with `git status --short --branch` and `git show --stat --oneline HEAD`. If the commit fails, report the exact error and do not claim success.
7. DO NOT run `git push` under any circumstances.
8. Provide a concise summary containing the commit hash, subject, meaningful body points, validation performed, and whether the worktree is clean.
