# Audit

Check an existing data app against the laws in this order: a broken frame makes every finding below
it unreliable. The patterns are starting points, adapted to the stack, and every hit is read before
it counts as a finding.

## 1. Frame and navigation

Is there one sidebar and one top bar, mounted by the layout and never by a page? Does the breadcrumb
come from the route pattern rather than the path string? Is the shell's back arrow the only way up?

| Look for | Pattern |
| --- | --- |
| A second panel or dialog implementation | `[Dd]rawer`, `[Mm]odal`, `[Ss]heet` as local components |
| A page shipping its own way up | `Back to`, `router.back` inside a page |
| A hardcoded panel width at a call site | `width: \d{3}px`, `width="4` beside a panel mount |

## 2. Heading and control row

Does every write action sit in the heading and none in the control row? Is the row absent where
there is nothing to control? Do filters live behind one menu and apply live?

Grep: `>Apply`, `Anwenden`, `applyFilters` for an Apply gate; `<select` or `Dropdown` inside the
control row markup for an inline filter; `pagination`, `items-per-page`, `pageSize`, `per_page`.

## 3. Content

Are all five states handled (loading, empty, error, degraded, ready)? Is loading a progress
indicator rather than a skeleton? Does a failed read offer a retry instead of an empty surface?

Grep: `[Ss]keleton`, `shimmer`, `placeholder-row`; `?? 0` and `|| 0` on figures the system does not
measure; `query.id`, `?record=`, `?open=` for panel state parked in the URL.

## 4. Writes

Does one dialog collect every input, with the confirmation being that same dialog in its dangerous
form? Is Save gated on dirty and validated on the server? Does only a finished outcome reach a toast?

Grep: `window.confirm`, `confirm(`, `alert(`; `toast` or `snackbar` in a submit handler's error branch,
where validation text is travelling in a toast; `type="number"`, `parseFloat(` on user input.

## 5. Behaviour and states

Is a missing grant a read-only page naming the grant, never disabled controls and never a blank
page? Grep `disabled` on fields and read each hit for whether read-only was meant.

## Click-through, desktop width

Open a list. Open a record in the panel and check the page under it is untouched. Resize the panel
and reload: the width survives. Expand to the record page, then leave by the back arrow. Create
through the dialog, delete through its dangerous form. Filter, then clear. Load a surface with no
rows and one whose read fails. Open a page as a role without write rights.

## Report

One finding per line: what is true of the app, the law it breaks, the target state. Sort by what a
missed finding costs. Close on the question that overrides the rest: can a colleague operate this
page without anyone explaining it? If not, the page is wrong even where every check above passed.
