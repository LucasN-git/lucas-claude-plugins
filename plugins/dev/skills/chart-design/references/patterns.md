# Chart patterns

Constructions that default tools get wrong, distilled from Chartosaur's redesigns. Each entry:
the predicate that selects it, how to build it, the slip to avoid.

Contents: Likert stack · Anchored diverging bars · Heatmap with marginals · Small multiples ·
Waffle versus pie · Beeswarm · Dumbbell and dot plot · Stacked bars with a net line ·
Histogram bins · Hexbin · Sparklines in tables · Shape-of-subject

## Likert stack

Predicate: one ordered scale with three or more levels per row (strongly agree … strongly
disagree). Form: a 100% stacked horizontal bar per row, levels in scale order from one end
to the other, neutral in the middle where it sits on the scale. Shades of one hue for the
agree side, shades of a second hue for the disagree side, neutral grey. Rows sorted by the
share the ask is about. Level names once above the top row; the story total (agree share) in
bold at the row end, segments unnumbered. "Don't know" leaves the stack into a side column
(see SKILL.md §4).

## Anchored diverging bars

Predicate: exactly two opposed measures per row (can trust / cannot trust, for / against),
not a multi-level scale. Form: a vertical anchor line in the middle, one measure growing
left and the other right, so the reader skims down and feels the balance without arithmetic.
Add summary rows (medians per group) that prove the title; the remaining rows give texture,
not a new story.

## Heatmap with marginals

Predicate: many values over two dimensions, at least one of them ordered (weekday by hour,
issue by week, state by year). Keep the axis order; add a bar chart above the grid summing
each column and one to the right summing each row, aligned to the cells, with faint
gridlines so sizes compare. When rows belong to families, the row bars carry the family
color; the grid itself stays one sequential scale that starts at zero so empty cells look
empty. It is a second chart lined up with the first (matplotlib GridSpec, seaborn heatmap,
ggplot2 with patchwork, Plotly subplots). In small multiples of heatmaps, a short caption per
panel names what to notice.

## Small multiples

Predicate: every series matters equally, or the panels tell a sequence. Shared axes on every
panel. Parts in a light shade, the total panel in a dark shade, which gives the reading order:
whole first, then parts. The slip: a shared x with different y-scales, where equal visual
distance means different amounts.

## Waffle versus pie

Predicate: shares that need to be compared. A waffle (10 by 10 grid, one square per unit,
colored by outcome) shows how widespread something is; one waffle per group compares groups.
A pie survives only for two or three clearly unequal shares.

## Beeswarm

Predicate: the spread itself is the story (salary by department, response time by region).
One dot per observation, none overlapping. Say what a dot is ("each dot is one metro area");
do not label dots when the chart is about the collective. An index axis with the average as a
labeled line, and a binary color at the cutoff consistent across panels.

## Dumbbell and dot plot

Predicate: two values per row (before and after, current and predicted). Direction version:
every dumbbell points the same way in two shades of one hue, lighter for current, darker for
predicted, rows unlabeled except the ones the story names. Discovery version: one dot per row
with the exact gain printed beside it, plain figure title, method note. Build one.

## Stacked bars with a net line

Predicate: inflows and outflows per category. Inflows stacked above zero, outflows below,
each side in shades of its hue, and the net drawn as a line so zero divides net contributors
from net recipients.

## Histogram bins

Start with Freedman-Diaconis: width = 2 × IQR / n^(1/3), bins = range / width. It fails on
very small samples, near-identical values (IQR near zero), long sparse tails and multimodal
data; there, adjust by eye until noise and shape balance. Never keep the tool's default count
unexamined.

## Hexbin

Predicate: a scatter above a few thousand points. Bin into hexagons; circles leave gaps,
squares impose a grid. Circles stay good as marks, not bins.

## Sparklines in tables

A small line per row gives direction and pattern beside the number, not scale. Where scale
matters, a hover or expand shows the axis; the default view stays clean.

## Shape-of-subject

Charts whose form mimics the subject (palm trees as bars, seats on an airplane) earn
attention in public feeds and give the data its natural context. They stay a chart only while
every number remains readable. For decisions, the plain form.
