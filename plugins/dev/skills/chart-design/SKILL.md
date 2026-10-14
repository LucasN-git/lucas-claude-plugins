---
name: chart-design
description: Use when choosing a chart form, or critiquing or redesigning an existing chart, heatmap, KPI tile or dashboard (Likert, pie vs bar, "too busy", "is this chart good")
---

# Chart design

Work in this order: name the job, build the structure that makes the job easy, put the answer
on the chart, color only the point, then title and source. Stop when the job is done; styling
after that point only adds noise.

## 1. One job, one audience

Say which job the chart does: comparison, trend, rank, part-to-whole, distribution, outlier
or relationship. If the data's type and the ask point to different forms (a Likert scale and
a "which do they agree with most"), the data type picks the form and the ask picks the sort
order and the highlight.

Compared items sit next to each other on one axis. If the reader has to scan across a gap
and hold a number in memory, the structure is wrong, whatever the styling.

Decide whether the audience came to **discover** values (every row carries its exact number,
plain figure title, method note) or to see a **direction** (one takeaway; row names and the
one number the takeaway rests on stay, everything else is grey and unnumbered). Build for
one.

Many series, one chart or several: when a few series are the story, keep all of them in one
chart with the story colored and the rest thin grey, and give the grey group one shared label
instead of one per line. When every series matters equally, split into small multiples on
shared axes.

## 2. Put the answer on the chart

Do not leave arithmetic to the reader. A stacked bar hides the net: draw the net as a line. A
heatmap hides which row or column is biggest: add marginal bars that sum each. A pattern the
title claims gets a summary row or labeled baseline that proves it. A share gets its absolute
base once: in the subtitle when one base holds for the whole chart, in one total column when
the base differs per row.

Order carries meaning: never sort a time axis or an ordinal axis. Where order is free, sort by
the value the story is about.

## 3. Color rules

- One color means one thing across the whole deliverable. Orange cannot mean "disagree" on
  one slide and "product F" on the next, and two adjacent panels never share a color for
  different categories.
- Subcategories take lighter shades of their parent's hue.
- A hue with an existing meaning in the domain beats an arbitrary one; where none exists,
  keep the palette the project or the `dataviz` skill already defines, including its
  color-blind pairing.
- Names of categories appear once, on or directly above the marks, never only in a legend.
  In a stack with more than three segments, print the story total per row and leave the
  segments unnumbered.

## 4. Encodings that cost trust

Bars start at zero. A line chart starts at zero too, unless the story is the change in a
series that never comes near zero (an index, a temperature, a share price); then the axis
prints its start value and the subtitle names the range. No dual y-axes. Small multiples share axes. Discrete time series use straight segments (in d3 or
Recharts that means the linear curve). Compare like with like: same measure, same window,
same method, and a window that starts at a peak or a trough is a story choice that the
subtitle has to name.

A response that is a point on the scale stays in the ordered stack, neutral included; a
response that is not on the scale ("don't know", "not applicable") leaves the stack and gets
its own small bar beside it in another hue, with the stack renormalized to the respondents who
answered and the side bar on the full base.

## 5. Title, subtitle, source

Title: the one sentence you would say aloud to sum up the chart, in plain language. Test it
against the chart itself: it claims nothing the marks do not show. "Drove all growth" needs a
total line; "at the expense of A" needs more than share data. If the test fails, weaken the
claim, not the chart.

Subtitle: what is measured, over what period, on what base (the sentence a descriptive title
would have been). Note line under the chart: source · exclusions · method. Both slots are
required; a chart without a source line is unfinished.

Annotations sit on the shape they explain. Axis labels name the direction ("more
concessions") instead of making the reader translate numbers or minus signs.

## References

Read `references/patterns.md` when the chart is one of the forms in its contents line (Likert
stack, anchored diverging bars, heatmap with marginals, small multiples, waffle, beeswarm,
dumbbell, stacked with net line, histogram bins, hexbin, sparkline table, shape-of-subject).

Read `references/dashboards.md` when the deliverable is a dashboard or KPI page.

Read the `data-storytelling` skill when the question is which claim or which window, not how
to draw it.
