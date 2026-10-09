---
description: Format for the root AGENTS.md and per-part AGENTS.md files created by pepi-project-setup.
---

# AGENTS.md format

Every `AGENTS.md` starts with frontmatter containing a one-sentence `description`, then an H1 title.
Keep files short and repo-specific; do not restate what the code or the other docs already say.

## Root `AGENTS.md`

Always exists. Holds only what applies to the whole repository and points to the parts.

```markdown
---
description: Main instructions for <repo>, covering tech stack, workflows, contracts, and documentation.
---

# <Repo name>

One or two sentences on what the product does.

## Broad Tech Stack

- Languages, frameworks, and datastores at a glance (one line per concern).
- **Quality:** linters, formatters, hooks.
- **CI/CD:** pipeline location.

## Documented workflows

- For <Part> work, read `<part-path>/AGENTS.md`.
- <the bullets from the Documented workflows template in SKILL.md, without the DESIGN.md bullet>

## Contracts and generated code

Only when parts share a contract or generated code (for example an API client generated from
OpenAPI): which files are generated, which build step regenerates them, and the compatibility rule.
```

- A single-part repository has only this file. Fold the part's sections (Stack, Verification,
  Conventions, Testing) below the workflows section instead of creating a second file.
- Omit `Contracts and generated code` when it does not apply.

## Part `AGENTS.md`

One per part (frontend, backend, database, infrastructure, and so on) when the repository has two or
more parts. Lives in the part's folder.

```markdown
---
description: <Part> engineering and validation instructions for <repo>.
---

# <Repo> <Part> Instructions

These instructions apply to `<part-path>` and add to the repository-root instructions.

## Stack

- Framework, language version, key libraries, test framework.

## Documented workflows

- Before UI work in this frontend, read `DESIGN.md`; update it when design tokens or component styling change.

## Verification

Stage 1 (while working): commands limited to touched files and direct consumers.
Stage 2 (finish gates): full non-mutating format, lint, build, and test commands.

## Conventions

Part-specific architecture, ownership, naming, and security rules.

## Testing

Test runner, test style, and what must be covered.
```

- Use only commands and conventions found in the part's manifests, configs, and code. Leave a
  section out rather than inventing content.
- The `Documented workflows` section with the `DESIGN.md` bullet exists only in frontend parts.
- Part files must not repeat root content such as branch, commit, or PR workflows.
