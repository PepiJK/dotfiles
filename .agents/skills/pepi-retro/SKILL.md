---
name: pepi-retro
description: Conduct a retrospective on a coding session to improve the agent's environment, guardrails, and instructions.
disable-model-invocation: true
---

# Retrospective

Conduct a retrospective on a coding session. Focus on improving the coding agent's **environment** (guardrails, navigation, instructions, tooling, and information access) so future runs are faster and make fewer mistakes. Read-only by default: present findings first and apply changes only after the user confirms.

## Process

1. **Read primary sources.** If the user does not specify a session, use the current session's conversation, edits, and tool calls. If the user specifies a past session (by ID, topic, PR, or timeframe), inspect the host's session history:
	- **GitHub Copilot CLI:** query the session store (`session_store_sql` when available) or inspect local session files under `$COPILOT_HOME/session-state/` (or `~/.copilot/session-state/`).
	- **Google Antigravity CLI:** inspect local session logs under `~/.gemini/antigravity-cli/` (or `~/.gemini/`) if available.
	- If logs cannot be found, ask the user for the session path or transcript.

2. **Inspect the existing environment.** Before suggesting changes, read the repository's current agent docs (`AGENTS.md`, `<part>/AGENTS.md`, `ARCHITECTURE.md`, `DESIGN.md`, `<docs>/adr/`), check commands (`package.json`, build files, linters, git hooks, CI workflows), and global instructions when relevant. Never propose a check or doc that already exists without noting why it was missed or unwired.

3. **Find improvement candidates.** Evaluate the session across these categories and keep only findings backed by concrete session evidence:
	- **Navigation:** How easily did the agent find the right files, contracts, or hidden dependencies? Would a pointer in root `AGENTS.md`, `<part>/AGENTS.md`, `ARCHITECTURE.md`, or `<docs>/adr/` have avoided wasted exploration? _Use when the session spent too long locating files or context._
	- **Automated checks (guardrails):** Could a linter, type-checker, formatter, test, or build check have caught a mistake the agent made? Check existing scripts, hooks, and CI first so an unwired or silently broken check is the finding, not a reinvention. A repository with no guardrail (no hook, no CI, and no documented verification command) is itself a finding. _Use when a mistake was mechanically catchable or guardrails are missing._
	- **Conventions and review rules:** Classify each violation first:
		- **Mechanical** (fixed syntax pattern, banned API, import shape, file-location rule): always prefer a deterministic check (linter rule, pre-commit hook, or CI step) over prose instructions.
		- **Judgement call** (cross-file consistency, architectural boundaries, domain terms, design patterns no linter can verify): add or clarify a concise rule in the narrowest fitting file (`<part>/AGENTS.md`, root `AGENTS.md`, `ARCHITECTURE.md`, `DESIGN.md`, or `<docs>/adr/`). _Use when the agent or review missed a convention or boundary._
	- **Instruction bloat and no-ops:** Check repo `AGENTS.md` files and global `.agents/AGENTS.md` for steering rules that can be replaced by an automated check, moved to a narrower scope, or deleted because they did not affect behavior or only restated what code and linters already enforce. _Use when instruction files are large, noisy, or ignored._
	- **Tool and context economy:** Did the agent run expensive, noisy, or redundant tool calls (broad searches, unpaginated logs, full builds when a targeted check existed, token-heavy custom CLIs or MCPs)? Propose tighter scripts, output filters, or a targeted Stage 1 vs full Stage 2 verification split. _Use when tool calls burned context or time unnecessarily._
	- **Information access:** Was runtime or external information missing (dev server logs not captured, missing read-only CLI/MCP access, undocumented env setup, missing test fixtures)? _Use when the agent was guessing because key signals were unavailable._
	- **Narrow workflow skills:** Did a repeated, multi-step specialized workflow cause friction that warrants a dedicated on-demand skill? Keep broad code-writing rules in `AGENTS.md`, not in skills. _Use only for narrow, recurring workflows._

4. **Present findings ordered by severity.** List candidates from highest to lowest impact. For each item include:
	- **Severity and category**
	- **Evidence:** what happened in the session (with file paths, commands, or turns)
	- **Proposed change:** the concrete fix and exact target file, script, or check
	- Ask the user which candidates they want applied.

## Where improvements belong

Choose the narrowest mechanism that solves the problem without bloating every future context window:

- **Deterministic checks (linters, typecheck, tests, hooks, CI):** First choice for anything mechanical. Zero ongoing context cost.
- **Root `AGENTS.md`:** Loaded in every session for the repo. Keep it short; hold only repo-wide stack, documented workflow pointers, cross-part contracts, and links to part `AGENTS.md` files.
- **`<part>/AGENTS.md`:** Loaded only for that part (frontend, backend, database, infrastructure). Put part-specific verification commands, conventions, and testing rules here.
- **`ARCHITECTURE.md`:** Structural map, core components, architectural invariants, data stores, integrations, and domain language.
- **`DESIGN.md`:** Frontend design tokens and component styling.
- **`<docs>/adr/`:** Short records for hard-to-reverse, non-obvious decisions with real trade-offs.
- **Global `.agents/AGENTS.md`:** Only durable, cross-repository personal rules. Never put repo-specific details here.
- **Skills (`.agents/skills/` or repo skills):** Only narrow, on-demand workflows or reference procedures, never broad coding rules.

## Writing rules for proposed agent-doc edits

When drafting edits to `AGENTS.md`, docs, or skills:

- Be concrete and specific to the repository: name exact commands, paths, symbols, and invariants.
- Prefer pointers to existing docs or scripts over duplicating their contents.
- State what to do directly; cut filler, hedging, and generic advice that could apply to any repo.
- Keep diffs minimal and additive so existing user-authored guidance is preserved.
