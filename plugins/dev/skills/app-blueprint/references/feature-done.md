# Feature: from request to done

## Decision rule

A feature is done when the real user can complete the task through their own interface, with their own rights, in a named environment, and someone has watched it happen. Everything below is a slot to fill; an empty slot is named in the completion report, not skipped silently.

## Before building

1. **Mirror the request as acceptance criteria.** A short list in the user's words, including the part that sounds hardest. If the request names a reference ("like X"), state which source wins where sources disagree; the most recently named reference outranks older material unless the user says otherwise.
2. **Ask the concept questions** through the question tool. Decide the details.
3. **Find what exists.** Shared components, an existing pattern for the same problem, a module that already solves half of it. New code is the last resort; `dev:good-ux` has the reuse ladder.
4. **Cut it into slices** that each end in something the user can try. One thing at a time; a large drop with many changes at once cannot be reviewed.

## While building

- **Only what was asked.** Each extra attribute, badge, toggle, status marker or explanatory block needs a reason the user would recognise. When unsure whether an existing attribute is still needed, evaluate it, remove it if not, and say why the rest stays.
- **Placeholders before polish.** A labelled empty box proves a concept as well as a rendered asset, and costs nothing to throw away.
- **Names users understand.** Plain domain words from the project vocabulary. Help text sits at the element and explains what makes the number or field meaningful; long explanations are collapsed by default.
- **Save intermediate results** to a file or commit; a chat is not storage.

## The slots of done

| Slot | Filled when |
|---|---|
| Criteria | Every acceptance criterion is met, or listed under "Not done" |
| Rights | Row visibility and role access are built, and tried from a non-admin account |
| Basic operations | Create, edit, delete, sort and filter exist for what the feature adds; saving works for any real change, including one that only adds a note |
| Blocked controls | Handled per `dev:good-ux` (forms): the user learns what is missing |
| Every channel | The feature is reachable in each user interface the project has (UI and user CLI), in the same change; the admin tool is never required for a user task |
| Both directions | Open and close, add and remove, apply and reset were each tried; the page state survives |
| History | New numbers are snapshotted like the existing ones |
| Docs in place | A non-technical explanation sits in the app next to the function; the project's instructions describe the new state as the current state |
| Checkers | Lint, tests and the project's checking skills ran, and their findings are fixed; a check added with the feature is able to fail the pipeline |
| Seen | The running feature was looked at in a named environment, item by item; no placeholder, raw key or stub value is visible |

## End-to-end check

After a module is built, walk the daily path from kickoff through the user's interfaces, as each role. Errors on the way must tell the user what to do next (which command, which login). A path that only an admin or a developer tool can complete is a finding, and so is every gap met on the way: it is not bridged with a developer tool. Findings go into a gaps document in the project's docs, one bullet each with its target state, so they can be worked through one by one.
