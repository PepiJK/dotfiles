---
name: pepi-interview
description: Research a repository and interview me about a complex problem, then write a detailed specification with solution steps for an implementing agent or for splitting into tickets.
disable-model-invocation: true
---

# Interview

Turn a problem description into a repository-grounded specification. The outcome is a Markdown spec an agent can implement directly or split into GitHub or Azure DevOps tickets. No code changes.

1. **Research first.** Establish the problem and the working directory's scope. Read agent instructions, docs, and ADRs, follow useful references, then inspect relevant code, configuration, and tests; consult external resources when the repository cannot answer. Answer every factual question yourself. Cite `file:line` for findings and surface conflicts between documentation and code. Done when each part of the problem is either grounded in evidence or listed as an open decision.
2. **Interview in rounds.** Map the open decisions as a tree: an answer may unlock further decisions. Ask only what repository and resource evidence cannot settle, and that changes the goal, requirements, scope, or solution shape. In each round, number and ask all decisions whose prerequisites are settled, then wait for answers. For each question show what the repo does now (cited), why the choice matters, the realistic options with consequences, and your recommended answer with reasoning; mark it provisional and name its assumption when evidence is thin. Phrase each as a concrete choice the user can make or correct. Investigate leads from each answer before the next round. Done when no open decision remains that would change the solution steps.
3. **Confirm shared understanding.** Summarize goal, requirements, decisions, constraints, non-goals, and the solution approach; ask the user to confirm or correct. Reopen affected decisions on correction. Write the spec only after confirmation.
4. **Write the spec.** Markdown with frontmatter (`title`, `created`) and these sections:
    - **Problem**: what is wrong or missing, and why it matters.
    - **Goal and non-goals**.
    - **Context**: repository facts with `file:line` references, kept apart from user decisions.
    - **Decisions**: each agreed answer stated precisely, including exclusions, defaults, and measurable requirements.
    - **Solution steps**: ordered, each naming the files or components touched, the change, and its dependencies. Make every step a vertical slice that is independently implementable and verifiable, so it can become one ticket.
    - **Acceptance criteria**: observable and checkable, per step and overall.
    - **Risks and open questions**: anything still unsettled.
5. **Save and present it.** Save at `<repo>/.scratch/interview/<slug>.md` with a short kebab-case slug from the topic; pick a distinct slug rather than overwrite. Print the absolute path and copy it to the clipboard (`Set-Clipboard` on Windows, `wl-copy`/`xclip` on Linux). Warn if the file is not Git-ignored. Report any save or copy failure explicitly.
