---
name: pepi-review
description: Review all current git changes (staged and unstaged) for logic errors, edge cases, and cleanliness.
---
# Instructions
1. Run `git diff HEAD` to see all staged and unstaged changes.
2. Analyze the diff focusing on:
   - Unhandled edge cases or missing error handling.
   - Accidental debug code (e.g., print statements, console logs).
   - Incomplete refactors (e.g., changing a variable name in one place but missing it elsewhere).
   - Possible Bugs
   - Logic errors
   - Clean code
   - DRY, code duplicates
   - Update to date documentation that aligns with the implementation
3. Ensure no hardcoded credentials or missing error handling are in the new code.
4. Provide a structured summary in a human readable format of your findings:
   - **Summary of Changes**: Brief overview.
   - **Potential Issues**: Bugs, edge cases, or dirty code.
   - **Suggestions**: How to improve the current changes before committing.
