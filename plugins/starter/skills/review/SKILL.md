---
name: review
description: Use when a branch needs a multi-angle review before its pull request, or after a large batch of agent-written changes
argument-hint: "[base] [--report-only]"
---

# Review

A branch review in one round: a few reviewer agents look at the diff from different
angles, you verify every finding against the code, a fixer applies what survives, and the
result lands in one HTML report. It is the heavier sibling of `starter:quick-review` and
the lighter sibling of a full multi-round review fleet.

You are the coordinator. Agents review and fix; you measure, run the gates, filter and
decide what reaches the fixer. Spawn each agent by name (`starter:review-quality`, …)
without a `model` override; its file pins the model.

## 1. Target and base

Target branch, first match wins:

1. a base the user named in the arguments
2. `gh pr view --json baseRefName -q .baseRefName`
3. `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`
4. `git symbolic-ref --short refs/remotes/origin/HEAD` (strip `origin/`)
5. `main`, then `master`, whichever exists

Then `git fetch origin <target>` and `base=$(git merge-base HEAD origin/<target>)`.
If the current branch is the target, stop: the review needs the branch under review
checked out.

## 2. Measure the diff

- `git diff --numstat $base` covers commits, staged and unstaged changes in one listing.
- Untracked files: `git ls-files --others --exclude-standard | xargs wc -l`.

Counted lines are added plus removed, leaving out binaries (`-` in numstat), lockfiles
(`*.lock`, `package-lock.json`, `pnpm-lock.yaml`, `uv.lock`), `*.md`, `*.snap`, and
generated or vendored paths (`dist/`, `build/`, `vendor/`, `*.min.*`). Test files are
counted on their own; they only decide whether the test reviewer runs.

## 3. Size the review

First matching row wins:

| Diff (counted lines, files) | Agents |
|---|---|
| > 3000 lines or > 100 files | none: stop and ask. The base has probably drifted, or the branch should be split. |
| ≤ 150 and ≤ 5 | `review-quality` |
| ≤ 600 and ≤ 20 | `review-quality`, `review-tests` |
| larger | `review-quality`, `review-tests`, `review-simplify` |

`review-tests` runs only when non-test source changed and the project has a test setup.
`review-fixer` runs at every size. Never more than four agents in total.

## 4. Preflight

- Record `git status --porcelain`. Empty → the fixer may commit. Anything listed →
  uncommitted work is part of the review, and fixes stay uncommitted.
- Gates: for each changed file, the `## Gates` section of the nearest CLAUDE.md above it.
  One shell command per line in a code block, run exactly as written. A `<changed-tests>` style
  placeholder is filled from the diff; a placeholder that fills empty means "not
  applicable" for that line. Lines starting `merge-only:` run once, at the end. No such
  section anywhere → record "no gates defined".

## 5. Gates and reviewers, in one message

In the same message: run the gates yourself, and spawn the chosen reviewers in parallel.
Each reviewer gets the changed-file list, the commit messages (`git log --oneline
$base..HEAD`), and `$base`. Their output contract is fixed in their own files: one line per
finding, `file:line | severity | defect | failure scenario | proposed fix`, at most ten.

## 6. Filter

You filter; there is no filter agent.

1. Open every cited line. Drop a finding the code refutes.
2. Merge duplicates across reviewers.
3. Drop theory without a concrete failure, style, and anything outside the diff.
4. Sort the rest:
   - **Apply** — verified, a concrete failure, a local fix with one obvious form.
   - **Decide** — the fix changes behaviour, an API or the product, or two or more fixes
     are reasonable.
5. Number Apply first, then Decide, in one sequence.

## 7. Ask about Decide items

If any Decide items exist, stop and print them as plain terminal text, one block each:

```
7. src/api/users.ts:88  Deleting a user leaves their sessions valid.
   a) revoke sessions in the same transaction (recommended)
   b) leave sessions, shorten their lifetime to 1h
```

Then state the reply syntax: `7` (take a), `7b`, `7 "own instruction"`, `all` (every
recommendation), `none`. Wait for the answer.

## 8. Fix

One `starter:review-fixer` call with the Apply items, the chosen Decide items, and the
commit policy: either "tree was clean, commit once with message `<message>`" or "leave
uncommitted". Skip the call when the list is empty or `--report-only` was passed.

## 9. Verify

- Re-run the gates (now including `merge-only:` lines).
- Read the fixer's hunks (`git diff` or `git show`) against each item. An item marked
  `done` whose hunk does not remove the defect moves to Open.
- A gate that was green before and is red now: one more fixer call with that failure.
  Still red, or red before the fix → Open.

## 10. Report

Write the report with `starter:html-output`, in this order:

1. Lead: verdict `ready for PR`, `changes required` or `major revision`, plus the one next
   action.
2. **Open** — unresolved items, failed gates, could-not items.
3. **Applied** (collapsed) — item, what changed, commit or uncommitted.
4. **Dropped** (collapsed) — one line each with the reason.
5. **Gates** (collapsed) — each command with its result, or "no gates defined".

The terminal message is the report path and the verdict, nothing more.

## Red flags

| Thought | Reality |
|---|---|
| "The reviewer quoted the code, I can skip the cited-line check." | Reviewers misread lines and invent context. Every surviving finding was read by you. |
| "A second review round would catch more." | One round is this skill's budget. Need more, run the heavier review. |
| "The fixer can run the gates." | You run them, before and after. A fixer grading its own fix is not a check. |
| "No gates section, so the gates are green." | No gates is "no gates defined" in the report, never "passed". |
