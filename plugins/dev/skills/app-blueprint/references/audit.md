# Audit: checking an existing app

## Procedure

1. **Scope it.** Whole app, one module, or a diff. If the user did not say, ask.
2. **Read the project's instructions and docs first.** They state what the app promises; the audit checks whether the promises are enforced.
3. **Walk the areas below.** Read-only. Nothing is fixed during an audit unless the user asked for that.
4. **Report** one bullet per finding: what is true of the system, why it matters, the target state. Sort by what a missed finding would cost. Findings that were fixed at the root elsewhere in the codebase are the standard for the rest; a workaround is itself a finding.

Adapt the search patterns to the stack; they are starting points, and every hit is read before it counts.

## Areas

### Source of truth

| Look for | How |
|---|---|
| Pick-lists as literals | arrays of labels in components, `z.enum(` / `enum` imported by forms, `options=[` |
| Thresholds as constants | bare percentages and cut-offs in calculation code: `0\.\d+`, `* 100`, `THRESHOLD`, `LIMIT` |
| Duplicate aggregates | the same sum or count computed in more than one query or component; two screens showing one figure |
| Process knowledge in prose | names, templates, step lists repeated across instruction or skill files |
| Numbers without a source | figures in the UI that no doc or help text attributes to a system, a person or a derivation |
| Missing history | metrics added after the snapshot mechanism that are not in it |
| One time per value | a value with an entry time but no time it holds from, and growth computed over entry dates |

### Foreign systems

| Look for | How |
|---|---|
| Access outside the adapter | client imports, hostnames, API keys used in more than one module |
| Write paths | `POST\|PUT\|PATCH\|DELETE` against foreign hosts; `INSERT\|UPDATE\|DELETE` on a foreign connection; connections not opened read-only |
| Unattended outbound actions | code that sends mail, invites or notifies without a human step |
| No inventory | no document that lists what depends on each system |

### Rights and user path

| Look for | How |
|---|---|
| Handlers without an auth check | routes that do not read the session or role |
| Row visibility enforced only in the UI | filters in components with no matching condition in the query |
| Admin-only paths for user tasks | a step of a daily workflow that needs the admin tool, SQL or browser automation |
| Channel gaps | features present in the UI and absent from the user CLI, or the reverse |
| Logs outside the logger | `console`/`print` in server code instead of the one structured logger; browser code and tests exempt |
| Missing basic operations | entities that can be created but not deleted, edited or undone |

### Promises without enforcement

| Look for | How |
|---|---|
| Checks that cannot fail | `allow_failure: true`, `continue-on-error`, `\|\| true`, skipped tests, lint not in the pipeline |
| Conventions with no checker | rules in the instructions file that no lint rule, test, hook or skill verifies |
| Silent no-ops in migrations | `DROP ... IF EXISTS` on a name that never existed; statements that succeed while doing nothing |
| The same rule in two places | instructions, skills and docs that restate each other and have drifted |
| Docs as change log | documentation that narrates changes instead of describing the current state |

### Repository hygiene

| Look for | How |
|---|---|
| Stale worktrees and branches | `git worktree list`, `git branch --no-merged`, local main ahead of or behind the remote |
| Half-finished features | branches or flags older than a few days with a module stopped mid-way |
| Placeholders in shipped code | raw translation keys, `TODO`, `lorem`, seed names, stub values in views |

### Consistency and states

Hand these to `dev:good-ux` in audit mode and to `starter:remove-ai-tells`; do not re-derive them here. Record only whether the project has a shared component library and tokens at all, and whether pages bypass them.

## Report shape

```
## Audit <scope>, <date>

Promises checked: <n>, enforced: <n>

1. <finding as a statement about the system>. Matters because <cost>. Target: <state>.
2. …

Not checked: <areas skipped and why>
```
