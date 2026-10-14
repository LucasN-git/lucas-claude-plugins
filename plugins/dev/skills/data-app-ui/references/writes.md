# Writes

## The dialog shell

One component for everything that collects input and saves it. Its inputs are: open state, title, submit label, busy flag, an error string, a gate override, width, a `danger` flag.

- The caller owns the draft and the visibility. The dialog owns the write: it calls the endpoint, puts its own failure in `error`, and emits the saved record upward. A form used at two moments (filed now on one surface, staged into a bigger save on another) only collects and emits, and each caller writes.
- Seed the draft when the dialog opens, not when it mounts. The shell outlives the row it was opened for, so a second Edit otherwise shows the first row's values.
- Enter submits, Escape cancels, the primary shows busy and refuses a second send while the request is out. A failure leaves the dialog open with the typed values in it; the message lands in the one error line under the fields, beside Cancel.
- Submit is gated on form validity by default; the gate override is for a dialog whose condition is something else. A long form scrolls inside the shell, because a card that clips loses its last fields and the buttons under them without saying so.
- A field that only means something at creation is absent when the same shell opens to edit. Offering it promises something that never happens.
- A submit that does more than the record it is named after states that in one sentence above the buttons, as a consequence, not an explanation.

## Confirmation

The same shell with `danger`, a verb as the submit label, and initial focus on cancel.

- The body names two things in concrete terms: what disappears, and what goes with it (the rows in other collections that hang off it). Where a reversible alternative exists, the body points at it.
- Type the record's name back to arm the submit, wherever the delete carries rows the reader is not looking at. A delete the server refuses while anything stands on it, or one the user can undo by acting again, keeps the danger submit and the sentence but needs no typed gate.
- Cancel runs on every close path unless submit already fired, so a side effect never runs twice. A reversible action asks nothing at all. Archive, hide, unarchive fire on the click and the button flips to its opposite.

## Editing a section of a record

Edit turns one section's fields into inputs. The control that started the edit becomes Save in the same place, so nothing moves and Save is never a screen below the fields it is about.

- Save stays shut until the draft differs from the record, and while any staged value is still being processed (a file decoding, an image normalising). A Save let through early sends an empty patch and closes reporting success.
- Only changed keys go to the server. An emptied text field normalises to null, and a submit with nothing in the patch closes without a request.
- Cancel re-seeds every field from the record and needs nothing from the form, so it can never be dead. A failed save renders at the top of the section, where the button that failed is, and a response landing after edit mode ended is dropped rather than staged.
- A section reused rather than remounted when the subject changes is keyed on the subject's id, or an edit made on one record renders under another's name.

## Writers that do not join the batch

A batch sends values. Anything that settles ownership, identity or a link is its own call in both read and edit mode: a link to a foreign record, picking which system's value wins, a revert to a source. So is a state move that carries rows the form is not showing, because behind a Save button it would behave unlike the same control everywhere else.

- Each of them says beside its label what it is about to do, through the hint icon. A write reaching rows the reader cannot see must not be a surprise afterwards.
- Any surface caching what such a write touched re-reads instead of patching in place. Patch-in-place stays fine for a save that touches one row.

## Validation

The server decides correctness, through a schema both sides share. Client validation is ergonomics; `dev:good-ux` holds its mechanics.

- A field the model no longer carries is refused with a message naming it, never stripped in silence. A stripped key means the save lands, the record is recomputed from what did arrive, and nothing records what the caller believed it wrote.
- A rule spanning two fields is checked where both are visible and reported against the one the user can act on. Each message names the field and what is wrong; "Required" is not a message.

## Where feedback goes

| Surface | What it gets |
|---|---|
| Field rule broken | the message at that field, never a toast |
| Submit failed in a dialog | the dialog's one error line, dialog open, values kept |
| Save failed in a section | one alert at the top of that section |
| Read failed for the whole page | the error surface with Retry |
| Finished outcome (saved, deleted, run complete) | a toast carrying the server's own sentence |
| A run that finished with errors | an error toast plus the errors in the surface, never a success toast |

A write that moved values also leaves a receipt in the surface: a persistent success alert listing before and after, with one Undo. It is an alert and not a toast because the body stays on screen under it and the undo has to stay in reach. Offer Undo only where the whole write can come back; a partial undo makes the button lie.

When one save is several calls, put back the call that already committed if a later one fails. Where the rollback itself is impossible, report what is still open rather than what failed, and lock the submit so a retry cannot create a second one.
