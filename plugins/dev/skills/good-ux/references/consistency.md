# Consistency and component reuse

## Decision rule

One thing, one look, one behaviour, everywhere. Users learn an interface once and then transfer what they learned; every inconsistency breaks that transfer and makes them check again. The mechanism that keeps an app consistent is reuse: every element comes from the shared components and design tokens, and a new component exists only for a real special case.

Before building any element, walk this ladder and stop at the first step that fits:

1. **Use** an existing shared component as it is.
2. **Configure** it through the props it already has.
3. **Extend** it with a new variant or prop, inside the shared component, so every other screen can use it too.
4. **Compose** a new component out of shared ones, and put it with the shared components if a second screen could need it.
5. **Build** a special component only when behaviour or data shape truly differs. Looking slightly different never qualifies: either the difference matters everywhere (add a variant) or it does not (drop it). Name it for what it is and say in the code why the shared one does not fit.

## What has to be consistent

| Layer | Rule |
|---|---|
| Components | One button, one input, one chip, one dialog, one table, one card per purpose. The five states also come from shared components (skeleton, empty state, error block, confirm dialog), each configured per situation with its own copy and action. |
| Tokens | Colours, spacing, radii, font sizes and shadows come from the token set. No raw hex values, no one-off pixel values. |
| Placement | The same action sits in the same place on every screen: primary action in the same corner, destructive action in the same colour, Cancel and Confirm in the same order. |
| Behaviour | The same gesture does the same thing everywhere; Escape closes, Enter submits, a link looks like a link. |
| Words | One term per concept across the whole app, the same verb for the same action ("Delete" everywhere, not "Remove" here and "Delete" there), the same date and number format. |
| Platform | Follow what users know from other apps (Jakob's law): native select, date input and scroll behaviour before a custom invention. |

## Anti-patterns

- A near-duplicate next to the shared component: `ProjectCardSmall`, `Button2`, a local `Modal` in a feature folder.
- Copy, paste and tweak instead of adding a variant. The two copies drift apart with the next change.
- The same entity shown three ways: a project as a card here, a row there, a chip elsewhere, each with different fields.
- A special component justified with "it is only used here", which is exactly how every duplicate starts.

## What to check in code

First find the shared component library and the token file, since everything is judged against them. Then run these outside those directories; hits inside the library are expected, only hits outside it are findings.

```
Raw values:     #[0-9a-fA-F]{3,8}\b|rgba?\(|-\[[0-9.]+(px|rem)\]|style=\{\{
Raw elements:   <(button|input|select|textarea|dialog)\b
Duplicates:     (function|const)\s+\w*(Button|Card|Modal|Dialog|Spinner|Skeleton|EmptyState|Table)\w*
```

Report duplicates grouped by purpose, each with the shared component that should replace it or the variant that would absorb it.
