---
name: pepi-project-setup
description: Set up or restructure a repository's agent documentation layout.
disable-model-invocation: true
---

# Set up repository agent documentation

Run this skill from the target repository. It surveys the repository, drafts one complete change
list, and applies only the items the user confirms.

## Fixed layout

Use the existing top-level folder whose name matches `docs` without regard to casing as `<docs>`;
when none exists ask wether to use docs or Docs. Keep the chosen casing throughout all paths and links.

| Path              | Purpose                                                                                            |
| ----------------- | -------------------------------------------------------------------------------------------------- |
| `<docs>/agents/`  | The four workflow guidance documents listed below                                                  |
| `<docs>/adr/`     | Architecture decision records; add `.gitkeep` only when the folder has no files                    |
| `<docs>/index.md` | Index of every Markdown file under `<docs>`, except itself                                         |
| `AGENTS.md`       | Root agent instructions, including `## Documented workflows`                                       |
| `ARCHITECTURE.md` | Root architecture overview, including `Domain language`                                            |
| `DESIGN.md`       | One per frontend, at the repository root for a root frontend and otherwise in each frontend folder |

The four workflow documents are `branch-template.md`, `commit-template.md`,
`issue-template-guidance.md`, and `pull-request-template.md`. Install the platform templates for
the detected host using the existing `references/platform/` files. These include the platform PR
template and issue or work-item templates.

| Platform     | Reference files                                                                                                                         | Target paths                                                                                      |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| GitHub       | `references/platform/github/pull_request_template.md`; `references/platform/github/ISSUE_TEMPLATE/{bug_report,feature,task}.md`         | `.github/pull_request_template.md`; `.github/ISSUE_TEMPLATE/{bug_report,feature,task}.md`         |
| Azure DevOps | `references/platform/azuredevops/pull_request_template.md`; `references/platform/azuredevops/work-item-templates/{bug,feature,task}.md` | `.azuredevops/pull_request_template.md`; `.azuredevops/work-item-templates/{bug,feature,task}.md` |

## Process

### 1. Survey

1. Resolve the repository root with `git rev-parse --show-toplevel`.
2. Detect the platform from `git remote -v`: `github.com` means GitHub; `dev.azure.com` or
   `visualstudio.com` means Azure DevOps. When the remote does not identify one platform, use an
   existing `.github/` or `.azuredevops/` folder. Ask the user if the result is still ambiguous or
   unavailable. If more than one top-level folder matches `docs` by casing, ask which one to use.
3. Resolve `<docs>` and inspect the root instructions:
    - If `AGENTS.md` exists, use it.
    - If only `CLAUDE.md` exists, plan to move it to `AGENTS.md` and create a one-line `CLAUDE.md`
      containing `@AGENTS.md`.
    - If neither exists, plan to create `AGENTS.md` with `# <repo name>` and the documented
      workflows section only.
    - If both exist, update `AGENTS.md` and leave `CLAUDE.md` unchanged.
4. Identify frontend folders by the code that renders UI. Look for frontend manifests or UI
   frameworks such as Angular and
   for component files used with stylesheets. If the root manifest identifies a frontend project,
   put its `DESIGN.md` at the root; otherwise make one in each frontend folder.
5. Classify every expected-layout path, each `DESIGN.md`, each applicable platform-template path,
   and each misplaced candidate as `missing`, `matches`, `drifted`, or `misplaced`:
    - `missing`: no file or equivalent source exists.
    - `matches`: the file is in place and satisfies its template or format requirements.
    - `drifted`: the file is in place but differs from its reference or lacks required content.
    - `misplaced`: equivalent content exists elsewhere and can be considered for a move.

    For the four workflow documents and platform templates, compare with the skill reference after
    substituting `<docs>` in platform PR links. For `AGENTS.md`, `ARCHITECTURE.md`, `DESIGN.md`, and
    `<docs>/index.md`, classify against the requirements in this skill and its format guides.

Check these deviation patterns, confirming equivalent content before proposing a move:

| Content            | Candidate locations                                                                                        |
| ------------------ | ---------------------------------------------------------------------------------------------------------- |
| ADRs               | `doc/adr/`, `docs/decisions/`, `docs/architecture/decisions/`, `adr/`, `decisions/`, `.agents/adr/`        |
| Architecture       | `docs/architecture.md`, `docs/ARCHITECTURE.md`, root `architecture.md`                                     |
| Domain terms       | `CONTEXT.md`, `CONTEXT-MAP.md`, `GLOSSARY.md`, `docs/glossary.md`                                          |
| Workflow documents | Any of the four workflow document names outside `<docs>/agents/`                                           |
| Design             | A frontend folder's `design.md`, `docs/design.md`, or root `DESIGN.md` when the frontend is in a subfolder |
| Workflow section   | `## Workflow templates` in root `AGENTS.md`                                                                |

Move only agent-layout material; leave unrelated content in `doc/` and other documentation
folders in place. Move an architecture candidate only when root `ARCHITECTURE.md` is missing and
exactly one candidate exists. If multiple candidates or a target conflict make a move ambiguous,
show the ambiguity and leave the files in place for the user's decision. Apply the same rule to a
root `DESIGN.md` that could belong to multiple frontends.

**Done when** every expected-layout row, every frontend design file, every applicable platform
template, and every misplaced candidate has a classification and proposed target path or a clear
reason it will remain in place.

### 2. Draft

Read the relevant format guide before drafting a new or refreshed document:

- `references/formats/ADR-FORMAT.md` for ADR naming, structure, and normalization.
- `references/formats/ARCHITECTURE-FORMAT.md` for `ARCHITECTURE.md`.
- `references/formats/DESIGN-FORMAT.md` for each frontend's `DESIGN.md`.

Draft `ARCHITECTURE.md` by exploring the repository. For an empty repository, create the title and
section-heading skeleton from its format guide with empty section bodies. For an existing file,
keep its structure and headings and add only missing applicable content, including at least
`Architectural invariants` and `Domain language`. The draft is ready when every top-level
repository folder appears in Project Structure, every runnable or deployable unit appears in Core
Components, and every data store and external integration found in configuration or code is named.

For each of the four workflow documents, copy the matching
`references/docs/agents/<filename>` file when its target is missing. Move a verified misplaced
copy to `<docs>/agents/` when that target is missing, and include every inbound-link update. For
drifted files, show a unified diff and preserve repository-specific additions; when the target and
misplaced copy both exist, list the conflict instead of overwriting or merging them silently.

Draft one `DESIGN.md` per frontend and extract tokens from that frontend's theme sources. Keep
existing content additive: preserve its structure and headings, add missing applicable sections,
and update token values only from evidence in the source. Move a verified misplaced DESIGN.md only
when its frontend destination is missing and exactly one frontend target is unambiguous; otherwise
show the ambiguity and leave it in place.

When root `ARCHITECTURE.md` is missing and Survey found exactly one misplaced architecture file,
move it to the root before applying the additive update. Leave candidate files in place when the
root target already exists or the source is ambiguous.

For ADRs, add `.gitkeep` only when `<docs>/adr/` has no files; leave an existing `.gitkeep` in
place. Move existing ADRs to `<docs>/adr/` and normalize their filenames using the ADR guide
without editing their contents. For `CONTEXT.md`, `CONTEXT-MAP.md`, `GLOSSARY.md`, or
`docs/glossary.md`, propose a separate, droppable merge item per file: move its domain terms into
`Domain language`, preserve all other content, and remove the source file only if it is empty after
the transfer.

Build `<docs>/index.md` from the post-move file set. List every `.md` file recursively under
`<docs>` except `index.md`, using paths relative to the index. Put files directly under `<docs>`
first without a group heading, then add one `##` heading per folder path that contains files
(for example, `## agents/sub`). Give each link a short description, reusing frontmatter
`description` when available. Omit empty folders.

Use this example as a shape, replacing it with the actual files and descriptions:

```markdown
# Documentation index

- [Top-level guide](guide.md): concise description.

## agents

- [Branch template](agents/branch-template.md): branch naming for issue-backed and maintenance work.
```

Add or update `## Documented workflows` in the root `AGENTS.md` using this template, substituting
the resolved `<docs>` path. Preserve custom bullets when updating an existing section. Replace an
existing `## Workflow templates` section in place; if both headings exist, consolidate their
bullets at the earlier location. If neither exists, insert the section after the introduction.
Include the DESIGN.md bullet only for frontend repositories, once per DESIGN.md. Put each bullet
in the frontend folder's existing `AGENTS.md` when present, otherwise in the root `AGENTS.md`;
substitute a path relative to that file (for example, `apps/web/DESIGN.md` in the root or
`DESIGN.md` in `apps/web/AGENTS.md`).

```markdown
## Documented workflows

- Before creating a branch, read `<docs>/agents/branch-template.md`.
- Before creating a commit, read `<docs>/agents/commit-template.md`.
- Before creating an issue or work item, read `<docs>/agents/issue-template-guidance.md`.
- Before creating or updating a pull request, read `<docs>/agents/pull-request-template.md`.
- To find documentation, read `<docs>/index.md`; update it in the same change whenever a Markdown file under `<docs>/` is added, removed, renamed, or repurposed.
- Before locating code or doing structural or cross-component work, read `ARCHITECTURE.md`; update it in the same change when structure, components, data stores, integrations, or invariants change, and add each settled domain term to its Domain language section as `**Term**:` with a one- or two-sentence definition followed by `_Avoid_:` synonyms.
- Before working in an area, read the ADRs in `<docs>/adr/` that touch it and flag any conflict explicitly; record a decision without asking when it is hard to reverse, surprising without context, and the result of a real trade-off, using `<docs>/adr/NNNN-kebab-slug.md` with a short title and 1-3 sentences on context, decision, and why, and supersede rather than rewrite a changed decision.
- Before UI work in this frontend, read `<design-path>`; update it when design tokens or component styling change.
```

Do not create a frontend `AGENTS.md`. For a repository with no root instructions, use the repository
name for the title and include only the documented workflows section.

For the detected platform, copy missing files from `references/platform/github/` or
`references/platform/azuredevops/`. Show a unified diff for any drifted file rather than silently
overwriting it. In a copied platform PR template, replace its `docs/agents` prefix with
`<docs>/agents`. Preserve repository-specific additions in every refresh; if a safe merge is not
clear, leave the file unchanged and call out the conflict.

**Done when** every new document has a complete draft, every existing document has a precise
additive update or refresh diff, and every move has its source, destination, and inbound-link
updates identified.

### 3. Present one change list

Group the full proposed change list under:

- **Moves:** each `git mv source destination`, any `CLAUDE.md` redirect, and every inbound-link
  update.
- **Creates:** each new path and its full content.
- **Refreshes:** one unified diff per file, including platform templates and any workflow document
  refresh.
- **Agent instructions:** diffs for the root `AGENTS.md` and any frontend-scoped `AGENTS.md`.

Include ambiguous or non-automatic items as explicit skips with the reason. Ask once whether to
apply the list; the user may remove or edit individual items before confirming. Make no repository
changes before confirmation.

**Done when** the user has confirmed the exact list to apply, or declined and no repository changes
have been made.

### 4. Apply

Apply only the confirmed items. Use `git mv` for tracked moves and a filesystem move for untracked
files. Preserve all user-authored content when moving, merging, or refreshing; carry forward any
custom text that is not part of the reference, and leave an item unchanged when that text cannot
be reconciled safely. Write new and changed text files with LF line endings and a final newline.
Do not commit.

**Done when** every confirmed item and no unconfirmed item has been applied, with all moved or
created text files retaining their content and final newline.

### 5. Verify and report

Confirm that:

- Every expected path exists with the resolved `<docs>` casing, including one `DESIGN.md` for each
  kept frontend.
- Every workflow pointer resolves from the `AGENTS.md` containing it.
- `<docs>/index.md` lists exactly the Markdown files under `<docs>`, except itself.
- Every inbound reference to moved paths points to the new path.
- No user-authored content was lost; inspect removed diff lines and ensure their content remains in
  a moved, added, or deliberately rewritten file.

Report created, moved, refreshed, skipped, and unresolved items factually.

**Done when** every verification check passes or its unresolved failure is reported, and the
change summary matches the final repository state.
