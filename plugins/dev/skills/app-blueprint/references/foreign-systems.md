# Foreign systems, side effects and cost

## Decision rule

A foreign system is anything the app does not own: a CRM, a product database, an analytics platform, a sourcing tool, a wiki, a cloud console. The app reads it; it does not write to it. Any exception is decided by the user, per system and per direction, and written into the project's instructions.

## Rules

**One door per system.** All access to a foreign system goes through one adapter, and what the app uses is a typed mirror of the data, not live reads scattered over handlers. Read-only is enforced where the connection is opened, so that an accidental write fails instead of landing. A name like "read-only user" is no guarantee: check what the credentials can do and report wider ones as a finding.

**Keep an inventory.** For each system: what is read, which screens and numbers depend on it, how fresh it is, what it costs. When a system is replaced or cancelled, the inventory is the rebuild plan. Until the replacement is known, the old integration is left as legacy: not extended, not torn out, and a call that fails because the system is gone is reported, not worked around.

**Ownership per field.** For every mirrored field it is clear who owns it. A wrong value in the source is fixed in the source; a wrong value that the app derived is an app bug. Local overrides are explicit and visible as such.

**Humans stay in the loop for outbound actions.** Agents prepare drafts; a person sends, because a mail, an invitation or an enrolment reaches real people and cannot be taken back.

**Ask before any of these, every time:**

- a write to a foreign system, including "just one test entry"
- anything that notifies or invites a person
- anything that costs money or changes a plan: cloud resources, paid API calls, seats, a non-free repository
- logging in to a third-party service on the user's behalf

State what will happen, to whom, and what it costs. Approval for one instance does not cover the next.

**Nothing waits without a limit:** every outward call has a timeout and bounded retries, every fan-out a concurrency cap.

**Check cost before integrating.** Before building on an API or CLI, find out whether it is metered or licensed, and tell the user the price next to the effort it saves.

**Buy before building.** Analytics, authentication, mail delivery and similar commodities are integrated, not rebuilt.

**Round-trip with the tools people already use.** Where users already live in a ticket system or a spreadsheet, input in the app should end up there (a created ticket with its attachments, an export in the familiar layout) instead of asking them to look in a second place.

**Vet what gets pulled in.** Before adding a dependency, plugin or external skill: who maintains it, does it auto-update, what can it reach. Say so briefly when proposing it.
