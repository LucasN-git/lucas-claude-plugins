# Success states

## Decision rule

Every completed action needs feedback the user can perceive. Scale the feedback to the weight of the action.

| Weight of action | Feedback |
|---|---|
| Milestone: onboarding finished, first project shipped, goal reached | A dedicated screen or a celebration, used sparingly so it keeps meaning |
| Meaningful mutation: payment, booking, submission, publish | An explicit confirmation with the relevant detail (amount, reference, what happens next) |
| Routine mutation: save, rename, toggle, move | A small signal, often the state change itself |
| Trivial, self-evident: a card dragged to Done and staying there | The action is its own confirmation, add nothing |

## Why it matters

The failure mode is specific: you pay a few hundred euros for a flight, hit confirm, and nothing visibly happens. Did it go through? Was I charged? Should I press again? That uncertainty is worse than a slow response, and it is what makes people double-submit.

## Patterns

- Confirm with the fact, not just the word. "Saved" is weaker than the item visibly moving, the timestamp updating, or the new row appearing.
- For anything with money or legal weight, show a reference the user can keep: order number, amount, date, and what happens next.
- If the mutation triggers a background job, say so honestly. "Export started, we will email you when it is ready" beats a checkmark that implies the file exists.
- Keep confirmation near the action, same as errors.

## Anti-patterns

- Silent success on an irreversible action. This is the single highest severity gap in the whole state model.
- Confetti on every save. Celebration inflation makes real milestones meaningless.
- A success toast that fires while the underlying list still shows stale data. Invalidate the cache so the UI actually reflects the change.
- Redirecting away so fast the user cannot register what happened.

## What to check in code

```
onSuccess|isSuccess|invalidateQueries|revalidate|redirect\(|toast\.success|router\.push
```

For every mutation found in scope, trace what the user sees afterwards. A mutation whose only visible outcome is a spinner ending is a finding. Check also that the button is disabled during flight, otherwise the missing confirmation turns into a duplicate submit.
