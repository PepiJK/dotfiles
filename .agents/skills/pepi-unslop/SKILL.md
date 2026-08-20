---
name: pepi-unslop
description: Edit drafted prose to remove AI-like patterns while preserving meaning, voice, code, configuration, quoted text, and required technical structure.
---

# Pepi unslop

Edit prose to remove AI patterns and add a human voice. Apply these rules only to prose that you are drafting or revising. Preserve code, configuration, command output, quoted text, and required technical structure.

## Process

1. Scan for the patterns below.
2. Rewrite. Preserve meaning and match the intended tone.
3. Add a human voice without inventing facts.
4. Self-audit: "What makes this obviously AI generated?" Fix remaining tells.

## Adding a human voice

Removing patterns is half the job. Sterile, voiceless writing is just as obvious.

- Have opinions when the facts support them. React to facts instead of neutrally listing pros and cons.
- Vary rhythm. Short sentences. Then longer ones that take their time. Mix it up.
- Acknowledge complexity when it matters. "Impressive but also kind of unsettling" beats "impressive."
- Use "I" when it fits the speaker and context.
- Let some informality in when the intended tone allows it. Do not make technical writing vague or sloppy.
- Be specific. Not "this is concerning" but "the agent can keep running after the terminal closes."

## Patterns to detect and fix

### Content

1. **Puffery.** "pivotal moment", "testament to", "evolving landscape", "setting the stage for", "indelible mark", "deeply rooted". Cut puffery and state what happened.
2. **Name-dropping.** Listing media outlets without context. Pick one, say what was said.
3. **Superficial -ing phrases.** "highlighting...", "ensuring...", "reflecting...", "showcasing...", "fostering...". Delete them or expand them with real sources.
4. **Promotional language.** "nestled", "vibrant", "breathtaking", "groundbreaking", "renowned", "stunning", "must-visit". Use neutral descriptions.
5. **Vague attributions.** "Experts believe", "Industry reports suggest", "Some critics argue". Name the source or delete the claim.
6. **Formulaic challenges.** "Despite challenges... continues to thrive." Replace it with specific facts.

### Language

7. **AI vocabulary.** Additionally, crucial, delve, enduring, enhance, fostering, garner, interplay, intricate, landscape (abstract), pivotal, showcase, tapestry (abstract), testament, underscore, vibrant. Replace these with plain words.
8. **Fancy ways to say "is".** "serves as", "stands as", "boasts", "features". Use "is" or "has".
9. **"Not just X, but Y."** State the point directly.
10. **Rule of three.** Do not force ideas into groups of three. Use the natural number.
11. **Synonym cycling.** Do not alternate between "protagonist", "main character", "central figure", and "hero" in one passage. Pick one and repeat it.
12. **False ranges.** Do not write "from X to Y" when X and Y are not a meaningful scale. List the topics directly.

### Style

13. **Em dash overuse.** Avoid em dashes. Use periods or commas instead. Do not replace every em dash with parentheses, en dashes, or hyphen-as-dash substitutes.
14. **Colon overuse.** Colons are fine before a list or example. Do not use them as mid-sentence connectors when a direct sentence is clearer.
15. **Boldface overuse.** Do not bold every proper noun or acronym.
16. **Inline-header lists.** A bold label followed by a colon that repeats the line is a tell. Convert it to prose. A bold lead-in that adds new detail is fine.
17. **Title case headings.** Use sentence case.
18. **Decorative emojis.** Remove them from headings and bullets.
19. **Curly quotes.** Replace them with straight quotes.

### Communication artifacts

20. **Chatbot phrases.** Remove "I hope this helps!", "Let me know if...", "Of course!", "Certainly!", and "Found the smoking gun!".
21. **Cutoff disclaimers.** Find sources or remove phrases such as "While specific details are limited...".
22. **Sycophantic tone.** Remove "Great question!" and "You're absolutely right!" Respond directly.

### Filler

23. **Filler phrases.** Change "In order to" to "To". Change "Due to the fact that" to "Because". Delete "It is important to note that".
24. **Excessive hedging.** Change "could potentially possibly be argued that it might" to "may".
25. **Generic conclusions.** State specific plans or facts instead of writing "The future looks bright."

### Jargon

26. **Abstract metaphor nouns.** Avoid words such as substrate, wedge, vector, locus, vantage, nexus, primitive (as a noun), harness (as a metaphor), surface (as in "API surface"), bedrock, scaffolding (as a metaphor), modality, paradigm, gold-plating, ratchet (as a metaphor), evacuate (for moving code), endgame, north star, and flywheel when a concrete word is available. "Substrate" becomes "base". "Wedge in" becomes "add". "Vector" becomes "way" or "method". "Gold-plating" becomes "more than the job needs". "Ratchet" becomes the mechanism's real name or "a limit that only tightens". "Evacuate" becomes "move out". "Endgame" becomes "the last phase".

### Plain speech

27. **Say what it does, not how it feels.** Replace "the database stays close at hand" with a mechanism or number, such as "`.toSQL()` returns the exact string sent to the database." If a sentence cannot be restated as a concrete instruction, fact, or number, cut it. If it could appear unchanged in another project's docs, make it specific to this project or remove it.
28. **Shorten or split dense sentences.** If the reader has to backtrack, break the sentence in two or drop clauses.
29. **Active voice.** Prefer it. Change "queries are validated" to "the compiler validates queries". Passive voice is fine when the actor is unknown or does not matter.
30. **Cut adverbs, or use a stronger verb.** Change "runs quickly" to "is fast" or provide the number. Change "significantly improves" to the measured difference.
31. **Prefer the plain word.** Change "utilize" and "leverage" to "use", "facilitate" to "help", "numerous" to "many", and "in the event that" to "if".
