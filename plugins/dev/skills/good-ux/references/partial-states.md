# Partial states and graceful degradation

## Decision rule

A page looks like one thing but is assembled from many sources at different speeds. Each region loads on its own, fails on its own, and the rest of the page stays usable.

The analogy that makes it obvious: ordering delivery from three restaurants. You do not expect all three at the same minute, and you do not throw away the food that did arrive because one order is missing.

## Patterns

**Independent boundaries.** One loading boundary and one error boundary per region, not one per page. In React that is a `Suspense` and an error boundary around each data-dependent block; in a plain fetch setup it is per-region state rather than a single page-level flag.

**Settle, do not race.** When a view needs several calls, `Promise.allSettled` lets partial results render. `Promise.all` throws the whole view away because one call failed.

**Degrade to something useful.** A chart that fails can show the last known value with a stale marker, or a retry button in the space it occupies. It should not blank out the dashboard around it.

**Rank by importance.** Render the primary content first and let secondary widgets arrive late. Navigation, headers and anything the user needs to leave the page should never wait on data.

## Anti-patterns

- A single top-level `isLoading` that hides the entire page until the slowest call returns.
- One failed request escalating to a full-page error, so a broken recommendations widget hides the account settings.
- Layout that reflows violently as each region lands. Reserve the space.
- Retry logic that silently hammers a failing endpoint with no visible state and no backoff.

## What to check in code

```
Promise\.all\(|Promise\.allSettled|Suspense|ErrorBoundary|error\.tsx|isLoading &&|if \(loading\) return
```

Two specific smells worth grepping for. `if (loading) return <Spinner/>` at the top of a page component is the whole-page gate. `Promise.all` in a loader that feeds several independent widgets is the all-or-nothing fetch.

Then ask the question that decides the finding: if exactly one of these sources is slow or down, what does the user still get? If the answer is "nothing", it is a real gap.
