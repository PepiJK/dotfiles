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
3. Ensure no hardcoded credentials or missing error handling are in the new code.
4. Also Check for possible bugs or logic errors, missed edge cases, clean code and DRY.
5. Run the `verify` skill (either by reading its instructions and executing them, or delegating if appropriate) to ensure tests and linters pass.
6. Provide a structured summary of your findings:
   - **Summary of Changes**: Brief overview.
   - **Potential Issues**: Bugs, edge cases, or dirty code.
   - **Verification Results**: Summary from running the `verify` checks.
   - **Suggestions**: How to improve the current changes before committing.
