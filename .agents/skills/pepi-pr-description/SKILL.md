---
name: pepi-pr-description
description: Creates a clear, human-readable pull request description that explains what changed and why, then copies it to the system clipboard.
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
- Review relevant source, configuration, tests, and documentation so the description explains behavior and intent rather than just listing filenames.
- Do not invent behavior, validation results, or completed work. Distinguish uncommitted work when it affects the description.

## Write the description

Unless a repository pull request template requires another structure, produce a polished,
ready-to-paste Markdown description with this adaptable structure:

```markdown
## Overview
<one or two sentences explaining the purpose of the change and why it was needed>

## Changes
### <logical area>
- <what changed and why>
- <important behavior, configuration, documentation, or architectural detail>

### <another logical area>
- <what changed and why>

## Impact
- <user-visible, operational, security, compatibility, or rollout impact when relevant>
```

- Use only the sections that add value. `## Overview` and `## Changes` are the normal minimum;
  add `## Impact`, `## Follow-up`, or another focused section only when relevant.
- Group changes by feature, concern, or outcome, not by commit or filename.
- Explain both **what changed** and **why**. Prefer concrete statements such as “Replaced X with Y
  so that Z” over vague phrases such as “updated several files”.
- Describe the resulting behavior or intent in plain language, including important user-visible,
  authorization, data, operational, or compatibility consequences.
- Keep the body concise but detailed enough for a reviewer to understand the change without opening
  every file. Use short paragraphs, bullets, and subheadings for easy scanning.
- Do not add a `## Testing` or validation section by default. Include validation only when the user
  explicitly requests it or a repository pull request template requires it.
- Do not invent rationale, behavior, or completed work. Base the explanation on the diff and relevant
  repository documentation; clearly distinguish committed changes from uncommitted work when needed.
- Do not wrap the final description in an additional code fence or add commentary to the copied body.

## Copy to the clipboard

Copy exactly the final Markdown, including its headings and bullets:

- On Windows, use PowerShell `Set-Clipboard`.
- On Linux, use the first available provider in this order: `wl-copy`, `xclip -selection clipboard`, `xsel --clipboard --input`, or `pbcopy`.

Verify the clipboard when a matching read command is available (`Get-Clipboard`, `wl-paste`, `xclip -o -selection clipboard`, `xsel --clipboard --output`, or `pbpaste`). If no provider is available or copying fails, report the error explicitly and show the final Markdown instead of claiming success. Do not install packages or modify repository files just to provide clipboard support.

Report the selected base branch and clipboard provider after a successful copy.
