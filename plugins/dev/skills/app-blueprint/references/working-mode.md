# Working mode: releases, branches, agents, status

## Decision rule

The user steers several sessions at once and is often not reading the code. They need to know at any moment what state the work is in, to trust that nothing ships without them, and to find the repository as tidy as they left it.

## Release gate

Violating the letter of this rule is violating its spirit.

- Finished work stops at the gate. The gate is the user's local main branch, unpushed, unless the project's instructions name a different one.
- Forbidden without a command from the user that names the step: pushing to a branch that deploys, merging or approving a merge request, setting auto-merge, triggering a deploy, applying a migration to a database with real data.
- Going live happens on that command, and then in one go, including watching the deploy and reporting the result.
- A failed release rolls back the code, never the migration, and old and new release overlap: migrations only add, an old worker fails an unknown job kind for a later retry, a retry after partial sends may reach someone twice.
- For coupled repositories, ship in dependency order (server before the client or plugin that calls it); a client released first sends commands into nothing.
- The gate is written in the project's instructions. If the user has to say it twice, it was not written down.

| Excuse | Reality |
|---|---|
| "It is finished and the pipeline is green" | Green is not approval. Finished work waits at the gate. |
| "They said ship it earlier" | Approval covers the step it named, not the next one. |
| "Merging locally is not going live" | Only if the local branch is not the one that deploys. Say which branch deploys before merging. |
| "The merge request is the normal way to finish" | Opening one is fine where the project wants it; arming it to merge is a release. |

## Branches and worktrees

- Short-lived branches, one concern each. A branch that changes design and logic at once is a merge conflict with a date.
- Work that touches more than one file starts in its own worktree and branch. `git stash` on a shared checkout is never used: it sweeps another session's work into the stash unseen.
- A worktree is removed as soon as its branch is merged.
- Before branching or committing, check for uncommitted changes that belong to someone else; never stage everything blindly.
- After a merge that touched auth, roles or navigation, run the non-admin smoke test before reporting.
- Resolve merge conflicts on your own where the intent is clear and name the decisions afterwards; ask where it is not.
- A feature is finished, or parked with its state written down (what is built, what is missing, where it lives), before the next one starts. Half-built work without a note is lost work.

## Several agents in one repository

- Know who else is working: list running agents, agree on file sets, and keep to your own. Changes outside the task's scope (another site, another module) are not made "while at it".
- One owner for shared counters such as version numbers.
- Larger work gets a second, separate reviewer, on top of the builder looking at the result, never instead.

## Talking to the user

- **Status on request** is three lines: what is built, what is merged, what is live; then what is open on each side.
- **Explain for a non-technical reader** before moving on: which tool, where they see what, how they share it. Reasons are owed for changes.
- **Findings and plans are lists** the user can work through, one bullet per item. Plans are schematic: diagram, arrow chain, small table.
- **A batch of unrelated requests** becomes a todo list worked top to bottom.
- **Ideas the user mentions in passing** are written down where they will be found again.
