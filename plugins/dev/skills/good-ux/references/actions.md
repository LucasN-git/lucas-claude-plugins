# Actions: hover, undo, risky actions

## Decision rule

Every action shows before the click what it does. Afterwards it can be undone; where it cannot, it has to be triggered deliberately by typing the name of the thing.

| Action | Way back | Guard before |
|---|---|---|
| Reversible: edit, move, archive, soft delete | Undo right where it happened | None, the undo is the safety net |
| Risky: permanent delete, delete with dependants, a change that reaches many records or other people | None, and the dialog says so | Type-to-confirm: the user types the exact name of the thing |

## Patterns

**Hover as information.** It confirms an element is clickable, previews what lies behind it, or adds a deliberate touch of personality. Choose per element, not one effect on everything. Touch and keyboard never hover, so what it reveals also shows on focus and is never the only way to a function.

**Always a way back.** Offer undo inline after every reversible action ("Moved to archive · Undo"). It is the confirmation, so no toast on top, and it stays until the next action, not on a timer. The browser back button returns to the previous view with its filters, tab and scroll position, because that state lives in the URL. Every dialog and every step of a flow can be left with Cancel or Escape, and closing it never discards what the user typed on the page underneath.

**Type-to-confirm for risky actions.** A plain "Are you sure?" is clicked away by reflex. Instead the dialog names the thing and what will be lost ("Deletes project Acme Website and its 142 files"), and the confirm button stays inactive until the user has typed the exact name. Label the button with the verb and the object ("Delete Acme Website"), never "OK".

## Anti-patterns

- A reversible action behind a confirmation dialog instead of an undo. It trains a blind "Yes" that then fails where it matters.

## What to check in code

```
group-hover:|onMouseEnter|confirm\(|AlertDialog|\.delete\(|undo|Undo|history\.|useSearchParams
```

For every write in scope, classify it as reversible or risky and check it against the table. `window.confirm` on a delete is a finding either way: too much for a reversible action, too little for a risky one.
