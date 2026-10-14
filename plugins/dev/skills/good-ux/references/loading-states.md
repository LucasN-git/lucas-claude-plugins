# Loading states

## Decision rule

Most loads are fast, and a skeleton or spinner that flashes for a split second is noise. Default to no indicator at all: build one only where the wait is known to be real (a slow query, an external call, a large list, or a wait seen with the network throttled), delay it by roughly 300 ms, and keep showing cached data while it refreshes. A region that is there within the delay gets nothing. Once a real wait outlasts the delay, match the indicator to its shape:

| Indicator | Use when | Why |
|---|---|---|
| Skeleton screen | A whole page or a large section is still loading after the delay and you already know the layout | The brain starts processing the layout before the data lands, so the wait feels shorter |
| Progress bar | The duration is known or measurable: upload, download, install, export | The user needs to judge whether to wait or walk away |
| Inline spinner | One small contained action that takes noticeably long: a button, one refreshing panel | A plain "working on it" signal, scoped to the thing that changed |
| Optimistic UI, no loader | A mutation that almost always succeeds and is cheap to roll back | Feels instant, and failure is rare enough to handle by reverting |

## Patterns

**Skeleton.** Mirror the real layout: same block sizes, same rhythm, same number of rows as a typical result. A skeleton that does not match what arrives causes a visible jump. Feeds do this well (Instagram, LinkedIn, YouTube): structure first, content fills in.

**Progress bar.** Show percentage or remaining time, and keep it honest. Myers (CHI 1985) found that a large majority of users preferred a progress indicator even when it was inaccurate, so an approximate bar still beats no bar. Pair long operations with a cancel action.

**Inline spinner.** Keep it inside the button or the panel. Disable the button while it spins so the action cannot be fired twice.

**Optimistic UI.** Apply the change immediately, keep the previous value, roll back and surface an error if the write fails. The like heart turns red before the server confirms. Only do this where a silent rollback is acceptable; never for payments or destructive operations.

## Anti-patterns

- A spinner on a file upload. With no progress, a slow upload reads as frozen and the user cancels or retries.
- A full-page loader that gates regions which could already render. See `partial-states.md`.
- An indicator rendered on the first frame of every load. On a fast connection it flashes, and the page feels slower than with none.
- A skeleton added because the region had no loading state, not because anyone saw it wait. Visible for less than its own fade, it reads as a glitch.
- Optimistic UI on an irreversible action.

## What to check in code

```
isLoading|isPending|isFetching|Suspense|fallback=|skeleton|Skeleton|loading\.tsx|shimmer
```

Check that each indicator is delayed and a refetch keeps the old data. Verify per region, not per page: a single top-level `isLoading` that hides everything is the most common finding.

Also check that the loading UI and the loaded UI have the same dimensions, otherwise the page shifts when data arrives.

