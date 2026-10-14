# Page types

A data app has six page shapes. Pick the shape first: it decides the chrome and what the page is
forbidden to grow. A page answering two of the questions below is two pages joined by a link.

## List page

Gets: heading carrying the create action, one control row (search, scope, filters, sort, then period
and count at the right end), a table, records opening in the docked panel.
Never: a second search field, a second control row.
Picks it when: the reader asks which one.

## Dashboard

Gets: a strip of headline figures, an entry point for what needs attention, aggregates linking through
to the page that owns them, one period control in its control row governing every widget.
Never: a widget with its own period, a figure leading nowhere.
Picks it when: the reader asks how things stand.

## Record page

Gets: heading with the back arrow and the record's actions, sections holding the record's own facts,
tabs for the collections hanging off it with their counts, the same blocks the panel mounts.
Never: a search field, a control row of its own; a collection tab carries the list's controls and panel.
Picks it when: the reader asks about this one.

## Form or wizard page

Gets: one column, one primary action per step, a visible step position, each step its own route so
the browser's back button works.
Never: a control row, a second primary, explanatory paragraphs above the fields, a silent block on
leaving with unsaved input.
Picks it when: an editor or a creation has outgrown a dialog.

## Settings and master data

Gets: every controlled value list editable in one place, a rail plus a pane where the lists are many,
one section per list where there are two or three, each showing its count and its purpose.
Never: a page-level create action over several lists, one card per entry stacked, a blank pane for a reader who may look but not edit.
Picks it when: the reader asks how this is configured.

## Reconciliation queue

Gets: one list of items to settle, the current item open, next and skip, a done count that can reach
zero, each act on the item needing it.
Never: a create action, a count including items carrying no act, one page per source system.
Picks it when: the reader asks what nobody has decided yet.

Canvas editors, presenter or wall displays and public pages are not shapes of this skill. Where a data app carries one, it is an own page under these laws, with the panel rules in `panel.md`.
