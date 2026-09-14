---
name: pepi-hunk
description: Loads the installed Hunk skill from the path returned by `hunk skill path`, then follows it for Hunk work.
disable-model-invocation: true
---

# Pepi hunk

Load Hunk's installed instructions before using Hunk:

1. Run `hunk skill path` in the current shell.
2. Read the file at the exact path returned by the command.
   - Bash: `HUNK_SKILL_PATH="$(hunk skill path)" && test -f "$HUNK_SKILL_PATH" && cat "$HUNK_SKILL_PATH"`
   - PowerShell: `$HunkSkillPath = (& hunk skill path).Trim(); if (-not (Test-Path -LiteralPath $HunkSkillPath -PathType Leaf)) { throw "Invalid Hunk skill path: $HunkSkillPath" }; Get-Content -Raw -LiteralPath $HunkSkillPath`
3. Follow the loaded skill for the rest of the Hunk task.

If the command fails or the returned path is not a file, report the error and stop. Completion means the resolved Hunk skill has been read and its instructions are being followed.
