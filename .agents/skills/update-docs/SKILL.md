---
name: update-docs
description: Update all .md files in this repo, analyze code for missing info, and keep docs simple and readable by LLM agents.
---

# Instructions

When invoked, you must:
1. Analyze the codebase to identify exported functions, architectural changes, or new features that are not currently documented.
2. Review the existing `.md` files in the repository.
3. Update the `.md` files to include any missing information found in the code.
4. **Keep it simple:** Write the documentation so it is easily readable by LLM agents. Use dense, structured formats like bullet points, clear headings, and code snippets.
5. Avoid overly conversational language; focus strictly on technical details, mechanics, and constraints.
