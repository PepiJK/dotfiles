---
name: pepi-commit
description: Analyze all changes made in git, then commit everything, but do not push.
---
# Instructions
1. Run `git status` to see what files are changed, added, or deleted.
2. Run `git diff HEAD` to analyze the actual content of all changes (both staged and unstaged) to understand the context.
3. Stage all changes by running `git add -A`.
4. Generate a concise, meaningful commit message based on your analysis of the changes. The commit message should follow standard git conventions (e.g., imperative mood, concise subject line).
5. Commit the changes using `git commit -m "<your_commit_message>"`.
6. DO NOT run `git push` under any circumstances.
7. Provide a brief summary of what was committed and the commit message used.
