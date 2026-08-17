---
name: pepi-pr-description
description: Creates a concise pull request description from the current changes against a selected base branch and copies it to the system clipboard.
---

# Instructions

Create a Markdown pull request description for the current repository changes and copy the final text to the system clipboard.

## Select the base branch

1. Determine the current branch with `git branch --show-current`.
2. Ask: `Which branch should I compare the changes to? [main/master]`
3. If the answer is empty or the user accepts the default, use `main` when it exists locally or as `origin/main`; otherwise use `master` when it exists locally or as `origin/master`.
4. If the requested branch is not available, ask for a valid branch instead of silently choosing another one.

Use the selected local branch or remote-tracking ref consistently for all comparisons. If the current branch is the selected base branch, tell the user that the branch comparison is empty and summarize only the current working-tree changes.

## Inspect the changes

- Inspect committed changes with the merge-base range `<base>...HEAD`, including the commit subjects and the complete diff.
- Inspect staged and unstaged changes with `git diff --cached` and `git diff`.
- Include untracked files from `git ls-files --others --exclude-standard`; read their contents before summarizing them.
- Read applicable pull request templates under `.github/` and follow their required headings when present.
- Review relevant tests, configuration, and documentation so the description explains behavior rather than just listing filenames.
- Do not invent behavior, validation results, or completed work. Distinguish uncommitted work when it affects the description.

## Write the description

Unless a repository pull request template requires another structure, produce only:

```markdown
## Summary
- <two to four concise bullets describing the user-visible or architectural changes>

## Testing
- <checks that were actually run and their results>
```

Use `Not run (not requested).` when no validation was performed. Keep the text concise, specific, and ready to paste into a pull request. Do not wrap the final description in an additional code fence or include commentary outside the Markdown.

## Copy to the clipboard

Copy exactly the final Markdown, including its headings and bullets:

- On Windows, use PowerShell `Set-Clipboard`.
- On Linux, use the first available provider in this order: `wl-copy`, `xclip -selection clipboard`, `xsel --clipboard --input`, or `pbcopy`.

Verify the clipboard when a matching read command is available (`Get-Clipboard`, `wl-paste`, `xclip -o -selection clipboard`, `xsel --clipboard --output`, or `pbpaste`). If no provider is available or copying fails, report the error explicitly and show the final Markdown instead of claiming success. Do not install packages or modify repository files just to provide clipboard support.

Report the selected base branch and clipboard provider after a successful copy.
