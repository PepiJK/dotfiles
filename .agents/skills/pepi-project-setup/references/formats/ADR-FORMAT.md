# ADR format

Use an ADR to preserve the reasoning behind a durable decision. Read the ADRs that touch the area
before changing it, and explicitly flag a proposed change that conflicts with one.

## When to record a decision

Create an ADR when all three statements are true:

1. The decision is hard to reverse.
2. The result would be surprising without its context.
3. The decision came from a real trade-off.

Routine implementation details, reversible choices, and decisions without a meaningful alternative
do not need ADRs. Record qualifying decisions without asking for extra permission.

## Location and naming

Store ADRs in `docs/adr/` using `NNNN-kebab-slug.md`, for example
`0001-event-sourced-orders.md`. Use four-digit numbers, increasing from `0001`; numbers are never
reused, including after an ADR is superseded. For a new ADR, use the highest existing number plus
one, or `0001` when none exists.

When normalizing existing ADRs, move them to the expected folder and normalize filenames only:

- Keep each assigned number, padding it to at least four digits.
- Convert the title or existing filename slug to lowercase kebab case.
- Number unnumbered ADRs after the highest assigned number, in first-commit order.
- Preserve each file's contents. If history cannot establish an unnumbered file's order or two
  files claim the same number, surface the conflict instead of choosing silently.

## Minimal content

Use a short title and one to three sentences that establish the context, the decision, and why it
was chosen:

```markdown
# Store orders in PostgreSQL

Order state must support transactional updates and operational reporting. Use PostgreSQL as the
write store because its transactions preserve the required invariants while SQL supports the
reporting workload.
```

Add only the optional details that improve understanding. A status may be recorded in YAML
frontmatter:

```yaml
---
status: accepted
---
```

Use `proposed`, `accepted`, `deprecated`, or `superseded by ADR-NNNN`. Add `## Considered Options`
when alternatives clarify the trade-off, and `## Consequences` when important effects are not
clear from the decision. No fixed-section template is required.

## Changing a decision

Write a new ADR for a changed decision, mark the old one `superseded by ADR-NNNN`, and preserve its
original reasoning. Do not silently rewrite or delete the old decision.

When a conflict is worth reopening, state it explicitly, for example:

> _Contradicts ADR-0007 (Use event sourcing), but worth reopening because the event volume and
> operational requirements have changed._

Add each new ADR to the documentation index in the same change.

## Sources

- Matt Pocock, `domain-modeling`, `ADR-FORMAT.md`, and `CONTEXT-FORMAT.md`, from the
  [skills repository at commit `c55ee46073ed923f86ce59a5eb3b6d895095d1b7`](https://github.com/mattpocock/skills/commit/c55ee46073ed923f86ce59a5eb3b6d895095d1b7).
- Michael Nygard, [Documenting Architecture Decisions (2011)](https://www.cognitect.com/blog/2011/11/15/documenting-architecture-decisions), for sequential numbering and superseding decisions.
