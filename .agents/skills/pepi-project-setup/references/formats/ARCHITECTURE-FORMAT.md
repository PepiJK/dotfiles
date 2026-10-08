# ARCHITECTURE.md format

Keep `ARCHITECTURE.md` a short, stable bird's-eye view and code map. Describe the system's
boundaries and relationships; name important modules and types without linking to source files,
because those links become stale.

## Sections

Use these headings in this order for a new document. Omit sections that do not apply instead of
adding empty placeholders:

1. `## Project Structure` - a concise map of the repository's top-level folders and their roles.
2. `## High-Level System Diagram` - the main units and the important control or data flows between
   them; a small Mermaid diagram is useful when it makes those relationships clearer.
3. `## Core Components` - every runnable or deployable unit, its responsibility, and its boundary
   with other components.
4. `## Architectural invariants` - rules that must stay true across changes, including dependency
   direction and boundaries. State the desired relationship directly, such as "The domain layer
   depends on contracts, not infrastructure."
5. `## Data Stores` - each database, cache, queue, or other persistent store, its owner, and its
   role in the system.
6. `## External Integrations` - each external service or system and the component that owns its
   integration.
7. `## Deployment & Infrastructure` - where runnable units execute and how they are deployed, when
   that information is relevant to the architecture.
8. `## Security Considerations` - trust boundaries, sensitive data flows, and security properties
   that shape the architecture.
9. `## Future Considerations / Roadmap` - known architectural directions or unresolved constraints,
   not speculative feature plans.
10. `## Domain language` - project-specific terms used consistently in code, issues, and tests.

For a new or empty repository, create `# Architecture` followed by all ten headings with empty
bodies. Do not add placeholder text. Omit inapplicable sections once the repository has meaningful
architecture content.

## Content rules

- Include every top-level repository folder in Project Structure; exclude Git's internal `.git`
  folder.
- Name every runnable or deployable unit in Core Components, and inspect code and configuration
  for data stores and external integrations.
- Describe stable relationships rather than implementation inventories, setup instructions, or
  development and test commands.
- Record invariants as affirmative rules that a change must preserve.
- Keep Security Considerations architectural: document boundaries and flows, not a copy of a
  security checklist.
- Keep Domain language specific to the product. Group terms under subheadings when natural
  clusters emerge. Format each entry as `**Term**: one or two sentences defining what it is,
  followed by `_Avoid_: synonym, synonym` when a useful synonym should be avoided. Leave out
  general programming terms.
- Add no project-identification metadata, contact details, or last-updated dates.

## Updating an existing document

Keep its existing organization and headings. Add missing applicable content without rewriting
unrelated sections; at minimum, add `Architectural invariants` and `Domain language` when absent.
As soon as a domain term is settled, add it to Domain language and use that term consistently.
Update Project Structure, Core Components, Data Stores, External Integrations, or invariants in
the same change when those facts change.

## Sources

- [architecture.md](https://architecture.md/), the overview template adapted for the section set.
- matklad, [ARCHITECTURE.md (2021-02-06)](https://matklad.github.io/2021/02/06/ARCHITECTURE.md.html), for a short code map and architectural invariants.
- Matt Pocock's `CONTEXT-FORMAT.md` at the
  [skills repository commit `c55ee46073ed923f86ce59a5eb3b6d895095d1b7`](https://github.com/mattpocock/skills/commit/c55ee46073ed923f86ce59a5eb3b6d895095d1b7), for the Domain language entry style.
