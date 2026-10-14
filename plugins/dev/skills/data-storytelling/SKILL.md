---
name: data-storytelling
description: Use when deciding what a chart, slide or report should claim (headline, time window, framing), or when a metric dropped and someone asks whether to act
---

# Data storytelling

A dataset supports a dozen honest readings, and teams hire the chart to confirm what they
already suspect. The job is to pick the story on purpose, back it honestly, and put the frame
in plain sight. How to draw the chart is in `chart-design`.

## Before choosing window, chart or title

When the deliverable makes a claim (a headline, a slide, a report finding), write these four
answers into the reply before the chart decisions:

1. **Opposite headline.** The intended headline and its opposite. If the data supports both,
   the window or the measure decides, and the subtitle names that choice.
2. **Starting assumption.** One sentence: what the requester expects to see.
3. **Window.** Why the series starts and ends here. A start at a peak flattens what follows;
   a start at a trough inflates it; "because it looks cleaner" means the story was picked
   before the data. When the zoomed-out view supports the opposite headline, deliver the
   zoomed-out chart with the requested span highlighted; the requested window alone is
   allowed only when both views agree.
4. **Objections.** The three objections a skeptic in the room raises (axis start, comparison
   basis, what was left out), each answered on the chart itself with a note, baseline or
   second window.

When the requester asks for a headline the data does not support, deliver the chart with the
strongest claim the data does support, state in one line which requested claim it drops and
why, and leave the decision with them.

## The claim

Title: the takeaway in plain language, defensible against the marks (the test and the
subtitle slot are in `chart-design` §5). A takeaway title sets the reader's search task;
"The West region carried Q3" and "Revenue was stable across regions" send the eye to
different places on the same chart, so choose the sentence for where the eye should go.

A story is a visual cue plus a takeaway title: the cue is the annotation on the shape that
carries the claim (the event behind the drop, the climb the sentence describes). Then remove
what neither adds to nor takes from the claim.

Wider audience, more interpreting on the chart: people who know the data read a figure;
people who know only the context need the takeaway on the chart; a general audience needs the
takeaway and nothing else.

## Before reacting to a dip

A dip is not automatically a thing to act on. Check these, cheapest first, and report which
were ruled out:

| Explanation | Check | If it is this |
|---|---|---|
| Incomplete right edge | Is the latest period fully attributed yet | Wait, or cut the last period from the chart |
| Measurement changed | Attribution window, tracking, definitions | Chart the old and new definition separately |
| Seasonal | Same period last year, not last month | Compare year over year |
| Noise | The move against the metric's usual swing | No action; widen the window |
| Pulled forward | A promotion before the dip moved demand earlier | Compare the sum of both periods |
| Market-wide | Did everyone's line drop | Report the category, not the company |
| One-off anomaly | Outage, payment blip, one large customer | Annotate it and exclude it from baselines |

Only a dip that survives this table is a signal.
