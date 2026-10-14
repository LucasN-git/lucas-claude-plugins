# Data and the source of truth

## Decision rule

For any fact the app depends on, ask: if this changes next month, who changes it, and how? If the answer is "a person, in the app", it is data with a screen to edit it. If the answer is "a developer, with a release", it had better be something the software acts on, not something people choose or tune.

## Rules

**Pick-lists are master data.** A value a person chooses from a fixed set comes from a curated list that is edited on one central page, not from an array in a component or an enum the form imports. The exception is a value the code branches on (a lifecycle status, a step type): that stays a code enum and is never offered as a free pick. A picked value that must also carry behaviour is a row pointing at a code-defined behaviour.

**Creating master data is its own step.** A combobox that finds no match offers "add '<typed text>'" as an explicit action. It never creates a record as a side effect of typing.

**Process knowledge is data, not prose.** Steps, templates, sender identities and rules that a workflow follows live in the database where the app and its agents read them. If the same knowledge is spread over instruction files, changing one name becomes a software release across a dozen texts.

**Thresholds and assumptions are settings.** A percentage, a guardrail or a cut-off inside a calculation is editable configuration stored with the data, and its meaning is written as help text at the element that shows the result.

**Every number names its source.** System, a person's entry, or derived. A number whose origin nobody can name is removed. Which environment the data comes from (test or production source) is part of the answer and is visible in the docs.

**One implementation per aggregate.** A total computed in two places will show two different values side by side. Compute it once and let every screen read that.

**Lists ask once, not per row:** counts in one query, a reorder in one statement.

**A foreign key gets an index** when a query filters or joins on it, or when its target can be deleted (the delete would scan the table); otherwise none.

**One database pool per process, from one shared factory,** with a connection cap and timeouts for statements and idle transactions.

**Only what is the same for every user is cached** in the process, invalidated by a write in the same step; nothing personal.

**Every metric gets history from day one.** A new number is snapshotted the same way the existing ones are, in the same change. History cannot be backfilled later.

**Every value has two times: since when it holds, and since when we know it.** A first entry of a value that was always there is knowledge changing, not the world changing. Growth is computed over the time it holds, never over the time it was entered: a delta compares only rows with a value at both ends of the window, a first entry counts from the row's own start date, a correction is not a movement. Where values are patchy, coverage (how much of the whole has a value) is its own number beside them.

**Notes and attachments are one-to-many.** Never one text field: they carry files and travel into a ticket or export.

**Global filters govern the whole page.** A period or scope selector applies to every widget on the page, or the widget says which period it shows.

**New modules couple loosely.** A new module shares as little as possible with the rest at the data level: its own tables, references by id, no reaching into another module's internals. It lives in the app without being woven into it.

**No test values in real data.** Placeholder rows, seed names and stub numbers stay out of any database that holds real data and out of anything handed over for review.

**Never show the storage format.** Users edit through an editor that fits the content; raw markup, JSON and keys never reach the screen.
