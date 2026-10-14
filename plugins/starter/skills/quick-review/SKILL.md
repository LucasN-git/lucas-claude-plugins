---
name: quick-review
description: Use when about to report a change as done, or on "review my changes" or /starter:quick-review
---

# Quick review

One cheap pass over the current diff before the work is called done. It catches wrong
logic, forgotten debug code, and docs that now describe something the code no longer
does.

Review after the last edit, never in the middle. A review of a state that no longer
exists reports findings that are already gone and misses the ones the last edit
introduced.

## Budget

One pass. Either in the current context, or in exactly one read-only subagent on the model
the framework assigns to judgment work, when the diff exceeds roughly 400 changed lines or
the context is already crowded. Never several reviewers in parallel. A wish for a second opinion is the signal
for a heavier review (see the last section), not for a fan-out here.

## Scope

Collect the diff, in this order:

1. Uncommitted changes (`git status --short`, `git diff`, `git diff --staged`).
2. Commits on this branch that the base branch does not have. Detect the base from what
   the repo actually has: `main`, then `master`, then `dev`. If the user names a target,
   use it instead.

Read the changed files and only what is needed to judge them: the function a changed
call lands in, the type a changed field belongs to, the test that covers the touched
path. No sweep of the wider codebase, no reading of files the diff never mentions.

## What to look for

In this order, and stop when the budget is spent:

1. **Correctness.** Wrong logic, off-by-one, inverted condition, states that are never
   handled (null, empty list, error branch, concurrent call), data loss (overwrite,
   delete without filter, migration without backfill), security holes in anything
   touching auth, SQL, shell, file paths or user input.
2. **Leftovers.** Debug prints, commented-out blocks, dead branches, TODO markers left
   from the work just done, hardcoded test values, stray credentials.
3. **Stale docs.** A CLAUDE.md, README or doc comment that names behavior this change
   altered. Only files the change actually contradicts.
4. **Missing tests.** Only where the project already tests the neighbors of the changed
   code. A project without tests does not grow a test requirement from this review.

Style stays out of it. A formatting or naming nit belongs in the linter. Raise one only
when the project has no linter and the nit hides a defect, such as a shadowed variable
or a misleading name on a boolean.

## Output

A ranked list, most severe first. Each finding is three parts:

```
path/to/file.ts:142  <what is wrong, one sentence>
  <what breaks in practice, one sentence>
```

Then one line of verdict: `ship`, or `fix 3 first`. Nothing found is one line:
`No findings, ship.`

The output is only that. No restated diff, no summary of what the change does, no
section praising what is good, no "consider maybe" hedges.

Drop, do not hedge: a suspicion that cannot be tied to a line, or cannot be told as a
concrete failure, is not a finding and does not enter the list with a softener attached.

## Fixing

Report by default. Apply fixes only when invoked with `--fix` or when the user asks for
them in the same breath. After fixing, name what was changed in one line per fix.

## Under time pressure

| Thought | Reality |
|---|---|
| "It is a one-liner." | One-liners flip conditions and drop awaits. Size predicts nothing. |
| "I tested it manually." | The manual test walked the happy path the code was written for. |
| "The user is in a hurry." | A wrong result costs more of their time than this pass does. |
| "I wrote it carefully." | The review reads the final state, which no single edit saw whole. |
| "It is only config or docs." | Config carries credentials, limits and feature flags. |

## When this is not enough

This pass is sized for everyday work. A change that touches database schema,
authentication, payments or several modules at once deserves `/starter:review`, unless
the project's own CLAUDE.md sets another threshold or tool. A change to a user interface
additionally needs a real browser walk-through, because a rendered screen has failure
modes no diff shows.
