# Drawer, modal, confirmation, feedback

How "more" opens over the page, how a destructive action is confirmed, and what the user sees afterwards.

## The drawer

- The editing surface: a detail, a record, anything with more than a few fields. Declarative: a small state holder with `open` and `record`, and a component bound to it. No imperative "open a panel" service.
- Docked right, full height, resizable at its left edge within the range in `SKILL.md`; the width is remembered per device. The backdrop is transparent and still catches the outside click: the page stays readable beside the drawer. Focus trap, the page underneath stays. Where a phone shell exists, the same component rises as a bottom sheet there (`dev:mobile-shell`, `layout.md`).
- Rendered into the sheet host, at the sheet layer.
- Motion: it slides in from the right by transform over the sheet duration; the content fades in after a delay so it arrives when the drawer has almost stopped. Reduced motion: it stands at once, content visible.
- Close paths: Escape, the outside click, the close button. Busy lock: while a mutation runs, none closes. The request itself times out first and shows its error inline; the lock's own 20 s expiry is the backstop so a hung request never traps the user.

## The modal

Centred, with a scrim, for two things only: a confirmation and a small form (two or three fields, no record behind it). A detail or an edit never opens in a modal. On the phone it renders as a sheet. Same stack, lock and reduced-motion rule as the drawer.

## Overlay stack

One list of open overlays (id and kind). Opening pushes or moves to top; every close path closes the top one only. Drawer over drawer is allowed and needs no new layer: the stack decides who is on top inside the one sheet layer.

Scroll lock is a depth counter, not a boolean, on the scroll surface: `overflow: hidden; overscroll-behavior: contain`, released by removing the property. Any library's own body lock is switched off so the two do not fight.

Focus trap, `role="dialog"`, `aria-modal`, return focus to the trigger: delegated to the headless primitive underneath; the shell adds the stack and the lock.

## Deleting

Two kinds, decided by what is lost:

- **A record or page** (it has history, links or children): a confirmation, never `window.confirm`. Three texts: title, what happens, and the consequence (what becomes irreversible). The danger button is outlined, never filled; initial focus is on cancel. On error it stays open with the message inline (`role="alert"`). Cancel fires on any close unless confirm was pressed first, so a side effect never runs twice.
- **A light thing** (a to-do, a tag, a row someone recreates in seconds): soft delete at once, and a toast offers undo. Undo restores the row; the delete becomes final when the toast leaves.

## Feedback

- Success is the state change: the drawer closes or the field shows saved, and the list shows the result. No success toast. If the result is not visible from where the user is, navigate to where it is.
- A toast exists only for an undo offer, an error that has no surface of its own (a background save failed) and a notice about something the user did not see happen (info); durations in `SKILL.md`. It is glass, at the overlay layer, never more than one at a time.
- A removed row fades out; the list re-lays out in one frame. No height animation.
- Errors of an action stay inside the drawer or form that caused them. Form and button behaviour during a request belongs to `dev:good-ux`.
