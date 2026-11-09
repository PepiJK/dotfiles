---
name: pepi-visualize
description: Use when asked to visualize, diagram, or explain a problem, bug, architecture, flow, or idea as an HTML page.
---

# Visualize

Turn a problem, bug, architecture, or idea into a self-contained, single-file HTML visualization in the One Dark theme. Visuals lead; text only labels and clarifies.

## Process

1. **Ground in facts.** When the prompt relates to a repository, inspect the relevant code, configuration, and docs first. Use real symbol names, data shapes, and `file:line` references instead of placeholders. When the prompt describes a standalone concept or greenfield idea, use concrete, realistic examples.
2. **Choose the visual form that fits the problem.** Combine forms when a problem has both structure and time steps:
	- **Flow, bug, or race condition:** Interactive step-by-step player (`Prev` / `Next` buttons and `←` / `→` keys, step indicator, active node/edge highlighting, and a live state or payload panel showing what changes at each step and where an invariant breaks).
	- **Architecture, topology, or data pipeline:** Clean inline SVG or CSS grid map with directional arrows, boundary groupings, and clickable or hoverable nodes that reveal responsibilities, payloads, and `file:line` locations.
	- **Refactor, trade-off, or design idea:** Side-by-side comparison (`Before` vs. `After`, or `Option A` vs. `Option B`) showing structural differences and concrete consequences.
	- **State machine, protocol, or data model:** State transition graph or schema map paired with concrete example payloads.
3. **Build a single self-contained HTML file.** Inline all CSS, SVG, and vanilla JavaScript. Do not load external CDNs, fonts, or scripts so the page works offline and opens instantly.
4. **Save and present.** Save at `<repo>/.scratch/visualize/<slug>.html` (or `<cwd>/.scratch/visualize/<slug>.html` outside a repository) using a short kebab-case slug; pick a distinct slug rather than overwriting an unrelated visualization. Open the file in the default browser (`xdg-open` on Linux, `Start-Process` on Windows) and print the absolute path.

## One Dark theme and styling

Define and use these CSS custom properties on `:root`:

```css
:root {
	--bg: #282c34;
	--surface: #21252b;
	--panel: #2c313a;
	--border: #3e4451;
	--text: #abb2bf;
	--text-bright: #e5e9f0;
	--text-muted: #7f848e;
	--blue: #61afef;
	--green: #98c379;
	--yellow: #e5c07b;
	--orange: #d19a66;
	--red: #e06c75;
	--purple: #c678dd;
	--cyan: #56b6c2;
	--font-sans: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
	--font-mono: "JetBrainsMono Nerd Font", "JetBrains Mono", ui-monospace, SFMono-Regular, Consolas, monospace;
}
```

### Semantic color usage

- **Surfaces:** `--bg` for the page canvas, `--panel` with `1px solid var(--border)` (`border-radius: 8px`) for cards and diagram nodes, and `--surface` for code blocks, payloads, and inset wells.
- **Status and meaning:**
	- `--blue`: active step, primary focus, and main control flow.
	- `--green`: valid state, happy path, or fixed "after" behavior.
	- `--yellow` / `--orange`: mutation, warning, bottleneck, or pending state.
	- `--red`: error, race condition, broken invariant, or buggy "before" behavior.
	- `--purple` / `--cyan`: distinct actors, services, queues, or data channels.

### Readability and layout rules

- **Visuals over prose:** Do not render a Markdown essay inside HTML boxes. Lead with the diagram, stepper, or comparison; keep text to short summaries, callout badges, and compact code or state snippets.
- **Typography:** Use `--font-sans` at `14px`–`15px` (`line-height: 1.5`) for prose and `--font-mono` for identifiers, `file:line` references, and payloads. Never use font sizes below `12px`, including inside SVG labels.
- **Collision-free SVG:** Give every `<svg>` an explicit `viewBox`, `<marker>` arrowheads for directed edges, and generous spacing between nodes so text labels never overlap lines or box borders. Use subtle tinted fills (`rgba(...)` of the semantic accent color) with solid 1.5px–2px strokes for highlighted nodes.
- **No visual slop:** Avoid neon gradients, glassmorphism, drop-shadow glow effects, decorative icons, or fake dashboard metrics. Keep contrast crisp and every visual element informative.
