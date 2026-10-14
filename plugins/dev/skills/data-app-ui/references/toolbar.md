# Control row and filters

## The seam

The heading carries what the page does. The row beneath carries what the page shows.

| | Heading actions | Control row |
|---|---|---|
| Holds | create, edit, approve, archive, delete, import, export, the link to the sibling view of the same subject | search, scope, filters, sort, period, result count |
| Effect | changes data, or leaves for a related destination | changes what or how you see |
| Writes | yes, or navigates | never |

The test when a control is hard to place: would it still make sense if the data were read-only? If yes it is a view control and belongs in the row; if no it belongs in the heading. Consequences that are not per-page decisions: the create action is a primary button in the heading, never at the right end of a filter row and never floating; where a page holds two lists and a page-level create could only mean one of them, create moves into each section's own header. Actions are visible and there is no overflow menu. The heading row wraps. What keeps it short is conditioning, not a cap: an action that cannot apply to this record in this state is not rendered, so publish and unpublish are never both there.

## Order

One row under the heading, wrapping, one gap step between items, fixed order at every width:

```
[Search] [Scope] [Filters ▾ ②] [Sort ▾]  ——spacer——  [Period] [N of M]
```

| Slot | Present when |
|---|---|
| Search | the list can plausibly exceed about 25 rows |
| Scope | a personal subset exists (All / Mine), as a mandatory two-button toggle |
| Filters | more than one thing can narrow the list |
| Sort | more than one order answers a real question |
| Period | the figures depend on a window; it sits at the right end, before the count |
| Count | always, once the set can be narrowed |

Search is leftmost at the fixed width, with a magnifier inside and a placeholder naming what is searched. A page never picks its own search width. Where a clear control writes an empty value as null, map it back to an empty string before anything downstream trims it. The row wraps and never reorders. Below the layout breakpoint the table beneath it scrolls sideways instead. There is never a second control row, and a row with nothing in it renders nothing: an empty bar, or a bar holding only a count, belongs in the table's own header band. Where search is a page's only narrowing, it is the table's header band control and the page renders no row at all.

## Filter menu

Every filter lives behind one trigger with a count badge. Inline filter selects on the row are forbidden, because they grow: two become five, five wrap to a second line, the order drifts from page to page, and the row stops being scannable. One trigger is one trigger whatever the page filters by. The trigger reads as a sibling of the search field beside it, same height, with a small chip carrying the number of active filters and nothing when that number is zero. The body is a menu that does not close on a click inside it, over a card with a minimum width, whose header row is the title and a Reset that is disabled while nothing is active. Two control kinds and no more: a tri-state toggle for a yes/no/any question, and a multi-select with removable chips for a facet. Facet options are computed from the unfiltered set, so choosing one filter never empties another's options. One function counts what is narrowing and the badge is that count; the defaults are a second function returning a state that narrows nothing. Never hand-write a second test for "is anything active".

Filters apply live. Free text that costs a server round trip debounces; filtering rows already on the client applies per keystroke; everything else applies on change, with the table showing its loading state. Any active narrowing force-opens collapsed groups, or a collapsed section swallows a match. A narrowed group states its narrowing rather than a fact: "12 items, none matching" and never "holds none". Active narrowings render as small removable chips at the end of the bar, one per narrowing, each naming the filter and its value and removing exactly that one, with a trailing Reset beside them. The chips do not exist while nothing is active: no empty strip, no "no filters" line. Search text is not a chip, since the field already shows it and carries its own clear control.

## Sort

Its own menu beside the filter trigger, its trigger carrying a chip that names the current order whenever the order is not the default, so the row states how the list is sorted without being opened. Each option carries one direction, the one that answers its question (Highest first, Longest untouched, A–Z), each with a one-line hint saying what that order means. There is no ascending/descending toggle. Every order ends on a stable tiebreak, usually the name, or the list reshuffles between two renders of the same data. Sort hides nothing, so it never raises the filter badge and never renders a chip; it does ride along in a saved default and in Reset. The table's header cell shows the indicator for the sorted column; the menu is where the order is chosen, and a clickable header that flips direction is not offered.

The result count is plain caption text at the right end: the narrowed count of the total, "N of M". It answers whether a filter did anything, which is the question a live-filtering row raises.

## Where view state lives

A view syncs to the URL where the view itself is the thing being shared: a canvas, a queue, a named preset. Write with a replacing navigation while the user adjusts controls, so switching a view does not fill the history stack, and omit default values so a clean view has a clean URL.

A list does not sync its narrowing. A list's filters are a person's working posture, returned to daily and shared almost never, and mirroring every toggle makes the back button walk backwards through filter changes instead of leaving the page. What a list persists instead is an optional saved default per user on the server, justified only where the list is somebody's daily work surface: saving captures the whole view state including sort, the page opens on it, clearing it restores the system defaults, and both controls sit in the filter menu under a rule with one line saying what they do. A link may hand a view over without the receiving page mirroring it back. A detail page reached from a row that carried a period reads it once at setup and never writes it again: it opens on the window the reader was already looking at, and back still means back. One-shot intents are different. `?new=1` and its siblings arrive from the palette or a stale bookmark, open the dialog or the mode they name, and are removed with a replacing navigation once consumed, or a reload re-opens the dialog. Consume them in a watcher on the query rather than on mount alone, since the same intent pushed from the page itself changes the query and remounts nothing. An intent no page reads navigates and then does nothing, which reads as a broken palette, so adding one is always two edits: the catalogue entry and the flag read on the destination page.