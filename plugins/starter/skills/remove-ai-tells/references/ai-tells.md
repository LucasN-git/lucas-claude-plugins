# Catalogue of AI tells

Every tell has a detection (via grep where possible) and a default fix. "House form" means:
the project's tokens and design rules, otherwise the neutral minimum from SKILL.md step 5.
Hits from the grep battery are candidates, not verdicts: every match is read before it falls.

## Contents

1. [A: Visual tells](#a-visual-tells)
2. [B: Copy tells](#b-copy-tells)
3. [C: Structural tells (page level)](#c-structural-tells-page-level)
4. [D: Not a tell (false-positive guard)](#d-not-a-tell-false-positive-guard)
5. [E: The framework look, forbidden as a whole](#e-the-framework-look-forbidden-as-a-whole)
6. [F: Grep battery](#f-grep-battery)

## A: Visual tells

| # | Tell | Detection | Default fix |
| --- | --- | --- | --- |
| A1 | Subtitle/lead/tagline under a heading; a stack of small text under a key figure | h1 to h3 followed by `.lead`/`.subtitle`/`.tagline`, or several short `<p>`/`<span>` | Delete; a statement of its own goes into body copy or a list; under a key figure exactly ONE caption stays |
| A2 | Eyebrow/kicker above the heading | `uppercase` plus `letter-spacing`/`tracking-*` plus an accent color above an h element | Delete, the heading stands alone |
| A3 | Chips, pills, badges, tags, especially with a status dot | Classes `chip`/`pill`/`badge`/`tag`, `rounded-full`, `border-radius: 999px`, `::before` dot | Pull the text into the sentence or cut it |
| A4 | Gradients on surfaces, buttons or text | `*-gradient(`, `bg-gradient-*`, `background-clip: text`, `bg-clip-text` | One color from the house form |
| A5 | Glow: colored shadow with a large blur | `box-shadow` with a color plus large blur, colored `drop-shadow`, `shadow-*-500/50` | The house form shadow, or none |
| A6 | Short bar under a heading | `h*::after` with a small width and 2 to 4 px height | Delete |
| A7 | Decorative icons in cards, widgets, lists | Icon component or `<svg>` inside card or list items with no function | Icon out, the content carries it |
| A8 | Cards everywhere: h2 above a grid of white boxes with a gray border, usually three | Card grids with border and radius in every section | Dissolve the boxes: h3 plus p directly on the surface |
| A9 | Step numbers "01, 02, 03" in an accent color | `0\d` as its own number element | Out, or as a real ordered list |
| A10 | Traffic-light colors for judgments (green/amber/red) | Status colors attached to evaluative statements | Judgment in words; colors only where they carry a defined meaning |
| A11 | Emoji as bullet markers or section icons | Emoji at the start of a line in markup or copy | Delete |
| A12 | "→" at the end of almost every button or link | Arrow suffixes on the majority of actions | At most on the one main action, otherwise out |
| A13 | Buttons in the framework default shape | 6 to 8 px rounded rectangles everywhere, `rounded-md`/`rounded-lg` with no house reference | One button shape, defined centrally, not per button |
| A14 | Everything centered; hover lift on every card | `text-align: center` at section level; `translateY(-Npx)` in every `:hover` | Left-aligned hierarchy; motion only where it has a function |
| A15 | Default or ad-hoc typeface | Inter or a system stack with no project reference, `font-family` outside the tokens | Trace it back to the project's typeface |
| A16 | Monotony: slate navy plus white plus light gray carry everything | No token other than gray or navy on the page | Raise it in the decision block, do not recolor on your own |

## B: Copy tells

| # | Tell | Rule |
| --- | --- | --- |
| B1 | Em-dashes "—" and en-dashes "–" in page copy | Split the sentence, or use a comma, colon or parentheses |
| B2 | Contrast structure "X, not Y" and "not only X but also Y" | Absolutely forbidden in headings. In body copy the words are allowed, as a recurring device they are not |
| B3 | Meta heading that describes the reading ("Four questions before you read on") | The heading names the subject, never the reading |
| B4 | Punchline heading ending in a period as a repeating pattern ("Do the math before you promise.") | Fine once; once it becomes a pattern, break it up |
| B5 | Heading with a colon and an explanatory tail ("Clarity: what really counts") | One statement per heading, cut the tail |
| B6 | Marketing filler: seamless, powerful, revolutionary, cutting-edge, unlock, empower, elevate, "In summary", "Conclusion" | A concrete noun or verb, or cut it |
| B7 | Forced groups of three, staccato across three or more parallel sentences | Vary the rhythm; three items only when the content has three |
| B8 | A label that is a whole sentence | Labels stay at about 4 words; the sentence moves into body copy or goes |
| B9 | A paragraph that repeats the headings below it | Delete with no replacement |

## C: Structural tells (page level)

| # | Tell | Rule |
| --- | --- | --- |
| C1 | Every section in the same meter: h2 plus paragraph plus three cards | Break the rhythm: a list, open typography, different densities |
| C2 | All cards the same height, all texts the same length | Length follows the content, not the symmetry |
| C3 | Duplicate CTAs: the same button repeated, two per section, stacked calls to action at the end | One main action per section |
| C4 | Pitch-deck scheme as page structure ("Why now / Why us / How it scales") | The page follows the subject, not the deck template |
| C5 | No hierarchy: everything the same size, everything equally important | One main thing per viewport, sizes jump visibly |

## D: Not a tell (false-positive guard)

- Exactly ONE caption under a key figure or a graphic
- A required notice, a source, a footnote
- Text in `aria-label`, `alt`, `sr-only`
- A line the project's design document explicitly calls for
- An exception documented in the code (a comment with a reason)

## E: The framework look, forbidden as a whole

The Tailwind/shadcn look is banned as a whole, not just single traits: boxes with an 8 px
radius, the `slate`/`gray` palette, gray 1 px borders around white cards, `ring` focus
rings, Inter or a system typeface, the preset shadows `shadow-sm`/`shadow-md`,
three-column feature grids. Single traits may appear inside a house form. Once several of
them together make up the look, the page counts as generated and gets rebuilt. Utility
classes in the code are irrelevant: the look is forbidden, not the tool.

## F: Grep battery

Candidate search across the scope (read the hits, then judge):

```bash
UI='--include=*.vue --include=*.tsx --include=*.jsx --include=*.svelte --include=*.html --include=*.css --include=*.scss'
# Visual
grep -rnE "gradient\(|bg-gradient-|background-clip: *text|bg-clip-text" $UI .
grep -rnE "drop-shadow\(|box-shadow: *0 0 |shadow-[a-z]+-[0-9]+/" $UI .
grep -rnE "border-radius: *(999|9999)px|50rem|rounded-full" $UI .
grep -rnE "(class|className)=\"[^\"]*(chip|pill|badge|tag)" $UI .
grep -rnE "uppercase|text-transform: *uppercase" $UI .
grep -rnE ">\s*0[1-9]\s*<" $UI .                     # step numbers
grep -rn "→" $UI .                                   # count arrows, do not delete blindly
grep -rnE "font-family|font-sans|Inter" $UI .
# Copy (markup plus translations)
grep -rnE "—|–" $UI --include=*.json --include=*.md .
grep -rniE "not only|but also|, not " $UI --include=*.json .
grep -rniE "seamless|powerful|cutting-edge|unlock|empower|elevate|revolutionary|best-in-class" $UI --include=*.json .
```
