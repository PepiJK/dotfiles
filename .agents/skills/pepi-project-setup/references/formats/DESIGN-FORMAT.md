# DESIGN.md format

Write one `DESIGN.md` for each frontend. Describe the visual system agents should preserve when
working on UI. Extract tokens from the frontend's existing theme and describe usage supported by
the implementation; do not invent values or design rationale.

## Preferred shape

Write the document as Markdown with frontmatter containing only a one-line `description`, then
`# <Project> frontend design`. Use this layout, omitting what the frontend does not have:

1. An opening paragraph naming the UI library and theme source, and stating that tokens are used for
   their intended purpose and never hard-coded or duplicated in a parallel palette.
2. A `Sources` paragraph listing the theme files to read before adding tokens, and how variables are
   loaded globally.
3. `## Colors`: a `Purpose | Variable` table (text, page background, surfaces, brand, neutrals,
   info, success, warning, error). State that status colors express state only. List local token
   additions with their one allowed purpose.
4. `## Typography`: font family, the size token scale with the base and small sizes, how headings
   are styled, and weights.
5. `## Spacing, radius, borders`: bullets with the token pattern and the key values.
6. `## Breakpoints`: how media queries consume them, since CSS variables are not usable there.
7. `## <UI library> theming`: palettes, where custom component themes live, and elevation.
8. `## Rules`: short bullets such as nesting, forbidden constructs, override placement,
   component-before-custom precedence, and accessibility.

Name tokens as the source defines them and show values only when the source defines them. The
token-map frontmatter below is optional and applies only when the frontend defines a token file
in that format.

## Optional token frontmatter

The frontmatter may also carry token maps. Frontmatter fields
supported by the pinned specification are:

| Field | Shape |
| --- | --- |
| `version` | Optional string; the pinned specification identifies its version as `alpha` |
| `name` | String naming the design system |
| `description` | Optional string |
| `colors` | Map of token names to CSS color strings |
| `typography` | Map of token names to typography properties |
| `rounded` | Map of scale names to dimensions |
| `spacing` | Map of scale names to dimensions or numbers |
| `components` | Map of component names to property maps containing strings or token references |
| `omitted` | Optional list of section names or `{ section, reason }` entries |

Typography properties may include `fontFamily`, `fontSize`, `fontWeight`, `lineHeight`,
`letterSpacing`, `fontFeature`, and `fontVariation`. The specification's `Dimension` values use
`px`, `em`, or `rem`; `fontWeight` may be numeric, and `lineHeight` may be a dimension or number.
Spacing values may also be numbers. Component values are strings or token references.

Reference another token with its object path in braces, such as `{colors.primary}` or
`{rounded.md}`. Keep token names and values tied to the theme source.

Use `omitted` for a token group or section with no source in the frontend. A reason is useful when
it explains an intentional absence; do not add empty token maps or fabricate defaults.

Use the section headings from Preferred shape above. A repository whose token files follow the
specification may instead use these `##` headings in this order, omitting those that do not apply:

1. `## Overview` (also known as `Brand & Style`)
2. `## Colors`
3. `## Typography`
4. `## Layout` (also known as `Layout & Spacing`)
5. `## Elevation & Depth` (also known as `Elevation`)
6. `## Shapes`
7. `## Components`
8. `## Do's and Don'ts`

An optional `#` title may precede the sections. Do not repeat a section heading.

## Extracting and describing tokens

Inspect the frontend's actual theme sources:

- Tailwind CSS v3 configuration or v4 `@theme` declarations.
- CSS custom properties, SCSS or Less variables, and design-token JSON.
- Theme configuration for Angular Material, MUI, PrimeNG, Chakra, or another UI library in use.
- Component styles when the tokens or variants are defined locally.

Record only defined values. Preserve source token names when practical, and describe only usage
observed in styles or components. For example, document a color's role only when its usage supports
that role; do not infer a brand personality, responsive rule, spacing scale, or component variant.
If a group has no source, identify it in `omitted` instead of making up a value.

## Updating an existing document

Keep its current structure and headings. Add missing applicable sections and update tokens only
when the underlying theme changes. Preserve useful repository-specific guidance, and keep prose
consistent with the values actually used by the frontend.

## Source

Google Labs, [DESIGN.md specification at commit `9bf8eae67128b6cc55ad9bf86665767deb4c11cd`](https://github.com/google-labs-code/design.md/blob/9bf8eae67128b6cc55ad9bf86665767deb4c11cd/docs/spec.md).
