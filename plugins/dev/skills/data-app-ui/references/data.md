# Data display

## The table

One table component per app, wrapping a virtual list. A page passes columns, rows, a loading flag and a sort; everything else is fixed by the wrapper so no page re-decides it.

- Virtual scrolling, no pagination control, no page-size selector, no density control, anywhere. Pagination asks the reader to hold a position in their head and turns "how many are there" into arithmetic; a result count above the rows answers that without a control. Density is decided once in the tokens, not discovered per user.
- The header stays stuck while the body scrolls, with the sort indicator in the header cell that is sorted, so the reader can always see which column ordered the rows. Column widths live in that same column definition, next to the title, the key and the alignment.
- Height is measured from the viewport and re-measured on resize and on every change of the rows. A hard-coded height leaves a strip of blank under a short table and clips a long one the moment the controls above it wrap. The loading bar collapses to zero height, so toggling loading does not shift rows under the cursor.
- Row click opens the record in the panel and marks the row selected. The record page is reached from the panel's expand action, the trail and links, never from the row: one gesture per destination. Inline row actions stop the click from reaching the row.
- Narrow screens keep the grid and scroll sideways. A table squeezed until its columns wrap is a table whose rows no longer line up, which is the one thing a table is for.

## Numbers

One module per unit family, and no surface formats a number inline. That module fixes the locale, the precision, the unit suffix and the form a missing value takes.

- Exact and compact are two functions and both are needed. A stated sum prints through the exact one, because a figure rounded to whole units disagrees with the document it is checked against. The compact one shortens a figure to fit a tile. The number locale is a separate decision from the interface language; pick one per unit family, in its module.
- Every numeric cell is right-aligned and set in tabular figures, and its unit is captioned once over the column rather than repeated in every cell. Proportional digits make a column unscannable, and a column that is not right-aligned cannot be compared downward at all.
- Null prints as "not tracked", in grey, with no delta beside it. Never a typed zero. A zero prints only where something actually measured it, and prints grey rather than green, because "nothing is stuck today" is not the same claim as "all clear". Blanking a real figure is a visible failure; a confident 0 for something nobody measures is read as a fact.
- One gate decides whether a figure may print at all, and every surface calls it. Three surfaces disagreeing about one measure is what this prevents.

## KPI tiles and the strip

A tile carries a value, a label below it, a delta as a smaller second line coloured up, down or flat (flat is grey, not green), and a hint icon where the figure needs a definition. The strip is a grid of equal columns directly under the heading, no cards and no borders, dropping to two columns at the narrow breakpoint in the numbers table.

- A delta on a ratio is wrong: the percentage of a quotient is not the quotient of two percentages, so render deltas for the two components instead.
- A tile whose subject is progress toward something draws a bar and prints a share. A figure that is not a share of anything is a plain stat, not a card with an empty track under it.

## The five states, per surface

`dev:good-ux` holds the general case. What this skill fixes:

| State | Renders |
|---|---|
| Loading | a progress indicator in the surface's own area |
| Empty | the empty state, naming which kind of empty it is |
| Error | the failure in the words of whoever knows, normally the server's sentence |
| Degraded | the data that did arrive, with the absence named on the thing that is missing |
| Ready | the content |

- Each card and each section owns its own three bad states. One failing card never blanks the page and never replaces a working card with a spinner. The read that owns the page carries Retry; a card that owns no fetch carries the message alone, because a button that fires nothing is worse than no button.
- Degraded names the source that did not arrive, and tells apart "nothing was ever recorded here", "the source has never been read", "the last read failed" and "the source says none". Each is a different person's job. A count from a failed read prints with its date rather than as a current number. Rows on screen that are stale after a failed refresh are a warning, not an error.
- A failed read never renders as an empty result or as a feature not built yet. The reader stops trying and the outage goes unreported.

Empty comes in three kinds, and they must not render identically:

| Kind | Says | Offers |
|---|---|---|
| Nothing matches the narrowing | which filters are active, and what clearing one would show | clear filters |
| Nothing exists yet | what would be here | the create action |
| This data does not arrive yet | plainly that, and where it will come from | nothing |

The third kind is the one that costs money. A blank list reading as "you have none yet" invites somebody to start typing figures that already have an owner in another system.

## Directing attention

- A state colour means the same thing everywhere in the app, and one colour is reserved for "needs action". A reader who learns it once must never meet it meaning something else.
- The dashboard carries a "needs attention" entry holding the rows waiting on a person, not a count of everything. Every aggregate drills down to the rows behind it, because a figure nobody can open is a figure nobody can check.
- A flow of quantities (leads becoming customers, budget becoming spend) is drawn as a Sankey, not a table. The finding is where the stream narrows, and a table of the same numbers hides it.
- A chart reads the page's global period filter. A chart with fewer than two points is not a chart: render nothing rather than a flat line through one value.
