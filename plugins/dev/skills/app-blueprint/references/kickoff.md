# Kickoff: what is decided before the first line of code

## Decision rule

Every item below is cheap to decide now and expensive to change once screens depend on it. Work through the blocks in order and do not start building while a block has an open concept question. Details the user waves off ("you decide") get decided and written down.

The blocks are a checklist for you, not a questionnaire for the user. Answer from the request and sensible defaults whatever can be answered that way, state those answers as assumptions, and ask only what cannot be undone cheaply later: usually five questions or fewer for a small app. Time pressure shortens the list of questions, never the list of blocks.

The output of kickoff is a section in the project's instructions file that states each decision as the current state of the system. A decision that stays in the chat is lost with the chat.

## The blocks, in order

### 1. Users and their daily path

- Who uses it, and how technical are they?
- Through which interfaces: web UI, a user CLI, an agent acting for them? Every one of these is a channel that features must reach.
- What does each role do on a normal day, as a walk-through of five to ten steps? The walk-through is the first end-to-end test.
- How do users report that something is wrong, and where does that report land (the ticket system they already use)?

### 2. Vocabulary

- One plain domain term per concept, checked with the people who will read it. No metaphors, no internal code names in the UI.
- The list of terms is written down; renaming after launch touches schema, UI, docs and habits at once.

### 3. Entities and process model

- The entities, their relations, and which of them are one-to-many from day one (notes, attachments, contacts almost always are).
- If the app runs a process: step types, sub-processes, what counts as evidence that a step is complete. Every step is opened once (which handles hide inside it) and placed once (which phase or cluster it belongs to); a step that resists either is cut in the wrong place. An editor for a process comes after this model, never before.
- For every attribute: who fills it in, and when? An attribute nobody fills in is not modelled.

### 4. Roles and row visibility

- The roles, what each may see and change, and whether visibility is per row ("only their own entries").
- Which parts of navigation each role reaches. Setup and master data sit in one place, shown by role, not duplicated per department.

### 5. Numbers

- For every number the app will show: its source (a system, a person's entry, or derived from other numbers), whether its history is kept, and whether the time it holds from differs from the time it is entered.

### 6. Foreign systems

- Which systems the app touches, in which direction, and what each costs. Default: read-only, through a mirror or adapter.
- What is bought rather than built (analytics, mail, auth).
- Details in `foreign-systems.md`.

### 7. Environments and the release gate

- Which environments exist, which branch each one shows, and which data each one holds.
- The release gate in one sentence, for example: finished work is merged into the local main branch; production happens only on the user's command.
- For coupled repositories (server plus client or plugin): the order in which they ship.

### 8. Design system and checkers first

- The shared components and tokens exist before the second screen. Pages built first have to be pulled back into line later, as a project of its own.
- The checkers exist before the generating starts: lint in the pipeline as a blocking job, the checking skills for look and states named in the project's instructions.
- The shell is decided by the kind of app: a data app (internal tool, records, roles) follows `dev:data-app-ui`; a consumer app follows `dev:desktop-shell`, plus `dev:mobile-shell` when it has a phone shell. For a small app this block shrinks to one decision: which component library and which linter, chosen before the first screen.

## What to hand back

A short schematic plan: entities as a small diagram or arrow chain, roles as a table, the build order as a numbered list in small slices that each end in something the user can try. Then the questions that are still open, if any.
