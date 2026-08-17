---
name: pepi-agent-hygiene
description: Audits and cleans up existing repository agent-instruction files for scope, duplication, staleness, and signal. Use only for instruction-hygiene reviews; do not use for ordinary skill creation or registration.
---

# Instructions

When invoked, audit and, when requested, improve existing repository agent-instruction files for scope, duplication, staleness, and signal. Do not use this skill for ordinary skill creation or registration unless the user explicitly asks for a hygiene review.

Respect the requested scope. For a repository-wide hygiene task, inspect the complete applicable instruction surface. For a bounded or read-only review, inspect only the requested files and supporting sources, and report any conclusions that could not be verified without expanding the scope.

## 1. Start with a needs analysis

Before making recommendations or editing any file, make a concise decision inventory:

- What does the model need to know that it cannot reliably discover, infer, or retrieve from the repository and its tools?
- What information can the model already discover, what do tools enforce, and what is duplicated elsewhere?
- Which instruction scopes and source-of-truth files are relevant to the requested work?
- Which existing rules are uncertain and require verification?

Summarize the decision inventory before editing. Do not start by shortening files or by assuming that every existing rule is unnecessary.

## 2. Discover the instruction surface

For repository-wide work, inspect the complete repository instruction structure, including:

- Root and nested `AGENTS.md` files.
- Repository-wide files such as `.github/copilot-instructions.md`.
- Path-specific instruction files such as `.github/instructions/`.
- Other agent instruction files only when repository tooling actually loads them.
- Setup scripts, configuration, and documentation that link, copy, or establish precedence for these files.

For bounded work, inspect only the applicable instruction structure within the requested scope. Read applicable instructions before changing them. Include untracked files and preserve unrelated user changes.

## 3. Gather repository evidence

Within the requested scope, read enough of the repository to identify facts that materially affect agent decisions:

- Architecture boundaries, ownership, and non-obvious legacy or generated-code rules.
- Authoritative build, test, lint, format, type-check, and generation commands.
- Intentional technology, API, error-handling, dependency, and testing choices.
- Security, compatibility, compliance, and operational constraints.
- Focused source-of-truth documentation and the scope where each rule applies.

Add information only when supported by code, configuration, CI, scripts, documentation, or another explicit repository source. Never invent commands, architecture, constraints, or team preferences.

## 4. Classify every existing instruction

For each meaningful rule in scope, choose one action and keep evidence for the decision:

| Action | Use it when |
| --- | --- |
| **Keep** | It is true, consequential, and difficult for the model to infer reliably. |
| **Remove** | It is generic, vague, duplicated, discoverable, enforced by tooling, obsolete, or model-coaching folklore. |
| **Move** | It is useful but applies only to a path, component, workflow, or task type. |
| **Verify** | It describes a command, version, dependency, workaround, or constraint that may have changed. |

Keep concise facts about system boundaries, local decisions, reliable validation, hard constraints, and where deeper truth lives. Remove or rewrite rules such as generic software advice, exhaustive file inventories, copied documentation, theatrical prompting, rigid model-specific rituals, and diaries of fixed failures.

Use strong words such as `always`, `never`, and `must` only for genuine hard constraints. Replace vague guidance with a concrete repository decision or remove it.

## 5. Improve the structure

Prefer this scope model:

- **Repository-wide instructions:** project context, shared architecture boundaries, universal decisions, common validation, hard constraints, and focused references.
- **Path-specific instructions:** conventions, generated-code rules, test patterns, and commands relevant only to a specific subtree.
- **Linked documentation:** detailed explanations, tutorials, architecture history, and rarely needed procedures.

Keep each fact in one appropriate place. Avoid conflicting or repeated rules across scopes. Keep the root file compact enough to load on every task, but do not remove necessary monorepo boundaries or operational knowledge merely to make it short. If a file is moved, update every loader, link, setup script, and reference that depends on its path.

## 6. Edit safely

- Change instruction files and directly related references only; do not change application code unless explicitly requested.
- Preserve valid user changes and existing repository conventions.
- Do not delete useful information without evidence that it is discoverable, enforced elsewhere, obsolete, or better represented at another scope.
- Do not preserve an unverified claim as authoritative merely because it already exists. Verify it, replace it with a reliable source-of-truth pointer, or report the unresolved gap for human review.
- Do not add instructions about how the model should role-play or reason. Describe the required outcome, local constraints, evidence, and validation instead.
- Do not commit or push changes.

## 7. Validate the result

After editing:

- Re-scan all instruction files in scope for duplication, contradictions, stale paths, and incorrect scope.
- Check that referenced files, scripts, and commands exist and match the repository's current tooling. Use safe, targeted validation; do not run deployment or destructive commands.
- Run the repository's applicable non-writing documentation or instruction checks when available.
- Run `git diff --check`.
- Re-read the final files, not only the diff, and confirm that the resulting guidance helps a capable model start useful work without teaching generic reasoning.

When practical, evaluate revised instructions on a representative, bounded task in a read-only or disposable context. Observe actual failure modes rather than imagined ones. Add guidance only for demonstrated gaps, then evaluate it on a different task when feasible. If no representative evaluation is performed, report that explicitly.

Do not claim a command or constraint was verified unless repository evidence or a safe check supports it. Do not run broad application test suites solely because instruction files changed unless repository rules require them.

## 8. Report the outcome

Report:

1. The needs analysis: high-signal information retained or added, and low-signal information removed or avoided.
2. The files inspected and their scope, plus each changed, added, moved, or removed instruction file when applicable.
3. The key `Keep`, `Remove`, `Move`, and `Verify` decisions, with unresolved verification gaps clearly separated.
4. Validation performed, including representative-task evaluation when used, and any remaining human decisions.

For a read-only review or a review that needs no edits, state that no files were changed and give the evidence-based findings or recommendations. Do not describe a shorter file as automatically better.
