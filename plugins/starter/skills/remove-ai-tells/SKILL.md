---
name: remove-ai-tells
description: Use when a page or its copy looks AI-generated (subtitle stacks, card grids, gradients), or after building a user-facing page
---

# Remove AI tells

Finds the patterns that give a generated page away and removes them from markup, CSS and
copy. Applies to any user-facing web UI, whatever the framework. The project's own design
rules come first; the catalogue here is fallback and checklist. It defines what is
forbidden, not what a project should look like.

**Core rule: this skill fixes. A run that only hands back a list of findings has failed.**
Exception: decisions that belong to a human (cutting a factual statement, giving a color a
meaning, introducing a new design form) go into a separate "Needs a decision" block and
are not carried out silently.

## Procedure

1. **Scope**: if the request names a page, its files count plus the copy it renders
   (including strings from i18n files). Otherwise `git status --short` /
   `git diff --stat`, filtered to UI files (.vue, .tsx, .jsx, .svelte, .html, .css, .scss,
   text JSON). Never the whole codebase.
2. **Load the project rules** (they beat the catalogue): the nearest CLAUDE.md, a design
   document if it points to one, the token file (colors, radii, type, shadows, durations)
   and a neighboring page as precedent. Before inventing a form, look for a house form
   that already covers it.
3. **Apply the catalogue**: read references/ai-tells.md before the first pass. Per file,
   in this order: markup and CSS, then copy, then the page as a whole (rhythm, repetition,
   hierarchy).
4. **Fix**: deleting beats rewriting. If a deleted line carries a statement of its own, it
   moves into body copy or a list; a pure transition goes away with no replacement. When
   the copy lives in translation files, all languages are changed in the same pass and the
   keys stay as they are.
5. **Replacement without a house form**: if the project has no tokens and no design rules,
   a tell is replaced by the neutral minimum: one text color, one surface color, at most
   one accent color, one radius, no shadows except a functional one, left-aligned, the
   project's typeface instead of an ad-hoc one. A new design idea belongs in the decision
   block.
6. **Verify**: run the project's check command (package.json or CLAUDE.md names it), plus a
   visual check wide and narrow, in every language the page has.
7. **Report**: two lines per file, what came out and where it went. Then the "Needs a
   decision" block. The page is not narrated back.

## Boundaries

Anything a regex can enforce (raw values instead of tokens, forbidden characters) belongs
in the project's build check. If such a check exists, the rule is proposed there and not
repeated here. Missing loading, empty and error states are the job of a UX-states skill,
correctness bugs the job of `starter:quick-review`.

## Rationalizations

Evading the letter of the rules is the same as breaking them.

| Excuse | Reality |
| --- | --- |
| "That's how the draft has it" | The draft supplies the content, not the look. Tells are dropped when the content is taken over. |
| "It makes the area look less empty" | Emptiness is designed calm. The tell is the decorative filler. |
| "Just a small hint under the number" | That is how the subtitle stack starts. Three small lines are two too many. |
| "Report first, fix on request" | The skill is called remove. Reporting without fixing is a failed run. |
| "Tailwind and shadcn defaults are neutral" | They are the most recognizable look of generated pages. |
| "The arrow shows it is clickable" | The button shows that. An arrow on every button is a tell. |
| "The card gives the content structure" | Three white boxes with a gray border are the template tell. Open typography carries the same content. |

## Red flags: stop and start over

- A second line of text appears under a heading or a key figure
- A heading contains "not only", "but also" or the shape "X, not Y"
- A new grid of three identical boxes appears
- A radius, a color or a shadow is missing from the token system, or there is no token
  system and the value was picked ad hoc
- The report runs longer than the diff of the fixes
