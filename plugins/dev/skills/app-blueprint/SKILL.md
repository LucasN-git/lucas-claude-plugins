---
name: app-blueprint
description: Use when starting a new web app with a database, roles or foreign systems, building a feature in one, reporting such work as done, or auditing one - /dev:app-blueprint
---

# App blueprint

Data apps rarely fail on code. They fail on decisions made after the building started, on "done" that nobody looked at, on extras nobody asked for, and on rules that lived only in a chat.

Interface states and component reuse belong to `dev:good-ux`, the generated look to `starter:remove-ai-tells`, the shell and UI behaviour to `dev:data-app-ui` for a data app and to `dev:desktop-shell` (plus `dev:mobile-shell` for a phone shell) for a consumer app. This skill does not repeat them.

## Three modes

| Mode | When | Read |
|---|---|---|
| **Kickoff** | A new app, or a new module with its own entities | `references/kickoff.md` |
| **Build** | Any feature in an existing app | the rules below; `references/feature-done.md` at the start of the feature and again before reporting done |
| **Audit** | "Check this app", or taking over a codebase | `references/audit.md` |

Three more references, each read when its topic is in play:

- `references/data-and-truth.md` when a change adds a table, a pick-list, a number shown to users, a threshold or a new module.
- `references/foreign-systems.md` when the app reads from, writes to or notifies through anything it does not own, or when something would cost money.
- `references/working-mode.md` before any merge, push, deploy or migration, and when branches, worktrees or other agents share the repository.

## The rules

1. **Decide before building.** Vocabulary, entities and process model, roles, the source of every number, and the design system are settled before the first screen. A tool built before the model it edits is built twice. (`kickoff.md`)
2. **One source of truth.** A fact lives in one place, and that place is data whenever people need to change it. (`data-and-truth.md`)
3. **Foreign systems are read through one door.** Writes, anything that notifies a person, and anything that costs money wait for explicit approval. (`foreign-systems.md`)
4. **Permissions are part of the feature,** built with it and tried from a non-admin account after every merge. (`feature-done.md`)
5. **Build what was asked, all of it, and nothing else.** (`feature-done.md`)
6. **The user's path is the test path.** A feature works when the real user can do it with the interfaces they have. Developer tools (browser automation, admin CLI, direct SQL) never stand in for that path; they only let the developer look at the result. A gap on the way is a finding, not an obstacle to route around. (`feature-done.md`)
7. **Done means seen.** Below.
8. **Releasing is the user's decision.** (`working-mode.md`)
9. **A rule without a checker does not exist.** Every convention gets something mechanical that runs before hand-over, and a check that cannot fail is not a check. Every decision lands somewhere durable (project instructions, data model, a skill), stated once; other places point to it.
10. **Ask about concepts, decide details.** Open questions about what the thing is go to the user before building, through the question tool, several at once, each with a recommended option. Without a question tool they go into the reply as a numbered list, and building still waits. Detail choices get made and then listed briefly. While an answer or approval is pending, work continues on whatever does not depend on it. A request to diagnose is answered with a diagnosis; "stop" holds immediately.

## Done means seen

Violating the letter of this rule is violating its spirit.

Nothing is reported as done, fixed, cleaned up or live until the running artefact has been looked at: the rendered page, the command's real output, the file listing after the cleanup. For a list of requests, each item is checked on its own, together with what the change did to its neighbours. When looking is not possible, the report says so; after two failed attempts at the same obstacle, report instead of trying a third time.

Every completion report has this shape, and stays this short:

```
Built:    <what, in the user's words>
Seen in:  <environment + branch + URL or command>, <how it was looked at> | not seen
State:    written, unverified | built | merged locally | live
Blocked:  <what stops verification and what is needed from the user, or "nothing">
Not done: <parts of the request left out, or "nothing">
Open:     <on my side> / <on yours>
```

| Excuse | Reality |
|---|---|
| "The code is written, so it works" | Blank pages, dead servers and raw translation keys all shipped behind that sentence. |
| "I checked the important items" | The one unchecked item of seven is the one the user finds first. |
| "The user is in a hurry" | A short honest "written, unverified" costs them less than a wrong "done". |
| "The result contradicts what I expected, I'll report it" | A surprising measurement is first a suspicion against the measurement. |
| "It runs locally" | Say which branch the local server shows. The user is looking at a different environment. |

Red flags, stop and look first: "should now work", a status without an environment, a placeholder or stub value anywhere in the hand-over, a cleanup reported without listing what is left.
