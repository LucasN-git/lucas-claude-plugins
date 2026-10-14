# Empty states

## Decision rule

A good empty state answers three things: why it is empty, what to do next, and that nothing is broken. If it answers none of them, the user assumes a bug.

This is often the first screen a new user ever sees, so it deserves the same attention as a headline feature.

## The four kinds

**1. First run.** A dashboard right after signup. Never leave it blank. Give one primary action ("Create your first project") and, where the product is complex, a short step-by-step path to a first result. Resist listing every feature; one obvious next step beats six equal ones.

**2. Section not yet used.** A tab or panel with no content yet. Say what the section is for and how to fill it. One sentence plus one action.

**3. Empty search or filter result.** Echo the query back, do not just print "No results". "No results for purple shoes" tells the user the search ran and what it searched for. Then give a way forward: a related query, a filter to drop, a spelling suggestion.

**4. Empty as the goal.** Inbox zero, no open tasks, no alerts. This is an achievement, so make it feel like one: an illustration, a line of copy, a small animation. A blank panel here reads as a failed load.

## Anti-patterns

- A bare white area with no copy at all.
- Copy that explains the emptiness but offers no action.
- The same generic "Nothing here" component reused in all four situations, which throws away the only chance to teach the product.
- An empty state that looks identical to the loading state, so the user cannot tell whether to wait.

## What to check in code

```
length === 0|length > 0 \?|\!data|data\?\.length|isEmpty|EmptyState|no results|Keine Ergebnisse
```

For each list, table, chart and search result in scope, confirm there is a distinct branch for the empty case, and that it differs from both the loading branch and the error branch. Three different situations, three different renders.

Check that the empty branch contains an action element (button or link), not only text.
