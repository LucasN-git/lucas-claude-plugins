---
name: data-app-ui
description: Use when building or auditing the UI of an internal data app (records, lists, roles, admin tool) - /dev:data-app-ui
---

# Data app UI

The shell and behaviour of a data app: an internal tool where people read, filter and edit records under roles. Colours, type and brand are not in it. A consumer app takes `dev:desktop-shell` (and `dev:mobile-shell`) instead; the two shells decide the panel, the confirmation and the loading state differently on purpose, and one app follows one of them.

Data, roles, numbers and the completion report belong to `dev:app-blueprint`; form ergonomics, undo and interface states in general to `dev:good-ux`; the generated look to `starter:remove-ai-tells`. Where this skill decides a state differently (progress instead of a skeleton; degraded and ready instead of partial and success), this skill wins for a data app.

## Three modes

| Mode | When | Read |
|---|---|---|
| **Kickoff** | A new app, or the first shell for an existing one | the questions below, then `references/shell.md` |
| **Build** | A feature inside an existing shell | the laws below; a reference only when its gate below holds |
| **Audit** | "Check this app", or taking over a codebase | `references/audit.md` |

References by topic, each read when its topic is in play:

- `references/shell.md` when navigation, the top bar, the trail or the page heading changes.
- `references/panel.md` when a record opens, closes or is edited from a list.
- `references/toolbar.md` when a list gets search, filters, sort or a saved view.
- `references/writes.md` when something is created, confirmed, saved or deleted.
- `references/data.md` when a table, a number, a chart or a state (loading, empty, degraded) is built.
- `references/page-types.md` when a new page is added and its shape is not obvious.

## The laws

1. **One shell, one navigation source.** Sidebar, top bar carrying the trail, one content sheet, one right panel. A page exists once it is in the single navigation file that feeds sidebar, breadcrumb and command palette. (`shell.md`)
2. **The heading is the noun, the row beneath it is the view.** What writes or leads to a related place sits in the heading; what narrows or re-presents sits in the control row. A control row never writes, a heading never filters. (`toolbar.md`)
3. **A record opens in the right panel:** docked, no scrim, resizable from a grip on its left edge, width remembered per panel key. The list stays visible and clickable; the panel lies over the page and never displaces it. (`panel.md`)
4. **The list reads, the panel details, the page owns.** Every record also has a permanent URL. Panel and page render the same blocks through the same components, and the open record never enters the URL. (`panel.md`)
5. **Creation and confirmation are one centred dialog shell** with one error line and one button order. An irreversible action is that dialog with `danger` and a real gate: the record's name typed back where the delete carries other rows. No native confirm, no second dialog implementation. (`writes.md`)
6. **The trail is derived from the route pattern,** not the path string. The pillar opens it and is never a link, the current page closes it and is never a link, everything between is a link; an id segment renders the registered human name. "Start > Dashboard > Analytics" is this trail, not a tab set; tabs exist only on a record page, for its collections. (`shell.md`)
7. **One way up:** the back arrow in the page heading, one level, resolved from the trail. No page ships its own "back to X"; a top-level page has no arrow. (`shell.md`)
8. **Loading is a progress indicator in the surface's own area, never a skeleton.** A skeleton asserts a shape before the answer is known. (`data.md`)
9. **Filters apply live.** Search leftmost at a fixed width, every filter behind one menu with a count badge, active narrowings as removable chips, sort as its own menu with one direction per option. No Apply button, no inline filter selects, no pagination, no density control. (`toolbar.md`)
10. **Save is gated on dirty, sends only the changed keys, and the server decides correctness.** A failure inside a dialog or section renders in that surface's error line; only a finished outcome becomes a toast. (`writes.md`)
11. **Permission is a permission, never a mode.** Same page, same layout; fields read-only rather than disabled, write controls absent, one line naming the missing grant. (`writes.md`)
12. **Every data surface handles loading, empty, error, degraded and ready,** and an empty surface says which empty it is: nothing matches the narrowing, nothing exists yet, or this data does not arrive yet. (`data.md`)

## Where a thing opens

| Situation | Where | Rule |
|---|---|---|
| Read one record from a list | Right panel | Row click opens it and marks the row selected; the same row again closes it; another row switches the record |
| Edit a record reached from a list | Right panel | One Edit per section turns that section editable, Save appears in place |
| The record is the subject of the visit, is linked to, or has records nested under it | Own page | Permanent URL, the trail leads to it, the panel's expand action opens it carrying the view state |
| Create a record | Centred dialog | Fields only meaningful at creation are create-only |
| Confirm something irreversible | Centred dialog, `danger` | Names in plain words what disappears and what it carries; typed-name gate where other rows go with it |
| Confirm something reversible | Nowhere | Archive, hide, unarchive fire at once and the button flips |
| Change one value, a link, an owner or a state | Inline | Writes at once, outside any Save batch, and says beside its label what it does |
| A collection hanging off a record | Tab on the record page | Sections are the record's own facts, tabs are its collections and carry their count |
| A view a room reads, or an editor longer than a viewport | Own page | Never a panel; a panel that needs a footer is the wrong shape |

## The numbers

Measured in one shipped internal tool. Perception values transfer as they are; sizes may be re-tuned once at kickoff, with the reason written next to the token.

| What | Value |
|---|---|
| Right panel | default 720 px, min 420 px, clamped to 90vw on read; grip 6 px, width written on pointer release; full width under 960 px |
| Frame | top bar 48 px; sidebar 232 px, rail 52 px, nav row 40 px; content sheet 8 px gutter, 24 px horizontal padding; heading row min 40 px |
| Control row | search 220 px; filter trigger 40 px; filter menu min 360 px; text that costs a round trip debounces 300 ms, client-side filtering per keystroke |
| Dialogs | 560 px; confirmation 460 px |
| Table | virtual scroll; cell padding 12 px / 10 px; 56 px rows and sideways scroll under 960 px; load more within 600 px of the end |
| Toasts | success and info 5 s, warning 6 s, error 7 s; bottom right, one host |
| Motion | one easing `cubic-bezier(.33, 1, .68, 1)`; 120 ms pointer feedback, 200 ms menus and chips, 400 ms panel and view change |
| Radii | 8 px controls, 12 px surfaces; pill only for the search trigger and count badges |
| Spacing | 4 · 8 · 12 · 16 · 24 · 32 |
| Empty and hints | empty state 64 px vertical padding, 48 px icon; hint icon 16 px, tooltip max 340 px; KPI strip drops to two columns under 600 px |

## Kickoff questions

Before the first screen, through the question tool, several at once, each with a recommended option: the pillars of the navigation and their order, and which paths each covers without an entry of its own; which record kinds carry collections of their own (they get tabs on their page); which list is somebody's daily work surface and gets a saved default filter; the roles, and per role which sections are read-only rather than absent; the free variables: colour, type, radius family and the component library. Everything else here is decided.
