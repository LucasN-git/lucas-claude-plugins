---
name: good-ux
description: Use when building or auditing an app screen that loads, submits or changes data
---

# Good UX: impulses on states

The UI failures users actually feel are rarely visual. They are missing states: a dashboard that renders nothing for two seconds, a payment that confirms nothing, so the user clicks again, a first run that looks broken because it is empty. The opposite failure is as real: a skeleton that flashes for 100 ms on a page that was already there. This skill gives impulses, two or three per screen, not a checklist to fill.

**Build mode** is the reference you consult while writing a screen. **Audit mode** is a pass over existing code that ends in the few changes a user would feel.

## The five questions

A region that depends on data can raise five questions in a user's head. Answer each in one line; the usual answer is "nothing needed", and for a region that is there within the indicator delay that is the right one. A state is built only where its question is real.

| State | The user's question | Load this reference |
|---|---|---|
| Loading | Is it coming? | only for a region known to wait longer than the delay: `references/loading-states.md` |
| Empty | Is it broken, or is there just nothing yet? | `references/empty-states.md` |
| Partial | Half of it arrived, is the rest coming? | `references/partial-states.md` |
| Error | What went wrong and what do I do now? | `references/error-states.md` |
| Success | Did that actually work? | `references/success-states.md` |

Four more references cover interaction rather than state:

- `references/forms.md` for anything the user types and submits.
- `references/actions.md` for hover states, undo and back navigation, and deletes or other risky writes.
- `references/progressive-disclosure.md` for screens that expose many options at once.
- `references/consistency.md` before writing any element that is not a shared component as-is, and when auditing for consistency.

## Build mode

Before anything else, find the shared component library and the token file; the screen is assembled from them. Read `references/consistency.md` before writing any element the library does not obviously cover.

Then name the screen's data-dependent regions, anything backed by its own fetch or mutation: the sidebar, the chart block, the feed, the save button. For each, one line per question above, plus whether it blocks the rest of the page.

Two defaults worth holding to unless there is a reason not to:

- Regions load and fail independently. One slow or broken source must not gate the whole page.
- No loading UI by default. A placeholder is built only for a region whose wait is known to outlast roughly 300 ms (slow query, external call, large list, or seen with the network throttled), shows after that delay and shares the frame of what arrives. One that would be visible for less than its own fade is worse than none; when unsure, leave it out and measure. Mutations that should feel instant get optimistic UI with rollback.

## Mobile and touch

Every screen also works with a finger on a narrow screen: tap targets at least 44 × 44 px and at least 8 px apart, no horizontal scroll at 360 px width, and inputs that open the fitting keyboard (`type="email"`, `inputmode="numeric"`).

## Audit mode

**1. Scope it.** A route, a feature directory, a component tree, or a diff; ask if the user did not say.

**2. Inventory the regions.** Find every data dependency in scope; the markers depend on the stack.

Reads, data-library stack:
```
useQuery|useSWR|useLoaderData|await .*\.from\(|fetch\(
```
Reads, plain hooks stack (useEffect plus useState, very common with a Supabase or REST client):
```
useEffect\(|supabase\.from\(|setLoading|setError|setData
```
Writes:
```
useMutation|onSubmit|handleSubmit|action=|\.insert\(|\.update\(|\.delete\(|\.upsert\(
```
Framework-level state slots:
```
Suspense|loading\.tsx|error\.tsx|ErrorBoundary|componentDidCatch
```

Where the app hand-rolls its states, the audit is whether the three flags (loading, error, data) each have a render branch.

**3. Locate each state per region.** For every region, find the code path that renders it. Record "none" rather than assuming a framework default covers it, and for loading add whether the wait justifies one. Common evidence:

- Loading: `isLoading`, `isPending`, `loading` state variable, `Suspense` fallback, skeleton component, `loading.tsx`
- Empty: `.length === 0`, `!data`, `data?.length ? ... : ...`, an EmptyState component
- Partial: independent boundaries per region, `Promise.allSettled`, per-section error handling
- Error: `isError`, an `error` state variable, `catch (`, `error.tsx`, ErrorBoundary, toast calls, inline field errors
- Success: post-mutation feedback, cache invalidation or refetch that visibly changes the UI, redirect, confirmation copy

An error boundary catches render errors, not failed mutations in handlers or unawaited promises; a `catch` that only logs counts as missing.

**4. Judge severity.** The rubric that decides most cases:

| Severity | When |
|---|---|
| High | The user cannot tell whether an irreversible action worked (payment, delete, submit). An important error only appears in an auto-dismissing toast. A first-run screen is blank with no next action. One failing region takes down the whole page. A permanent delete, or a change that reaches many records or other people, fires without type-to-confirm. A placeholder that flashes: appears and vanishes within a blink on a load that was fast anyway. |
| Medium | Whole-page loader gates regions that could render independently. Wrong indicator for the wait (spinner on a long upload). Empty search result with no query echo and no way forward. Blocking modal with no path forward. Reversible action with no undo. A hand-built duplicate of a shared component, raw colour or spacing values instead of tokens, or the same action named, placed or behaving differently on two screens. Tap target under 44 px or horizontal scroll at phone width. |
| Low | Missing character counter, missing prefill, formatting the user could have been spared, cosmetic inconsistency between states. |

**5. Report.** Findings by severity, each naming the file, the region, what a user experiences, and the concrete fix. Only what a user would feel; a region without loading UI that is there within the delay is not a finding, and neither is an empty cell as such. The matrix below only when an audit of the whole screen was asked for.

```
Region              Loading   Empty   Partial   Error   Success
/dashboard charts   skeleton  ok      missing   toast   n/a
```

**6. Offer, do not auto-fix.** Finish with the two or three fixes worth doing first. Only change code when the user asks for it.

## Judgement calls

- Not every region needs all five, and fewer is usually better: every added state is UI the user watches in transition. A static header has none. A never-empty list has no empty state. Say why you skipped rather than silently dropping it.
- Some empty states are the goal, not a failure. Inbox zero and a cleared task list should feel earned, not broken.
- The cleanest confirmation is often the action itself. A card that moves to Done and stays there needs no toast on top.
- Do not hide critical functions behind progressive disclosure. Fewer visible options is only better when the user can still find what they came for.

State model after Katherine Gilligan's "building with good UX" series; the references keep her examples where they make a rule concrete.
