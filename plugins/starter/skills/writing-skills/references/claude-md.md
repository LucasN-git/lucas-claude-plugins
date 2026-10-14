# CLAUDE.md

1. [Where an instruction belongs](#where-an-instruction-belongs)
2. [What earns a line](#what-earns-a-line)
3. [Bridging AGENTS.md](#bridging-agentsmd)
4. [The Gates section](#the-gates-section)

## Where an instruction belongs

| The instruction | Goes in | Because |
| --- | --- | --- |
| applies to every task in the repo | `CLAUDE.md` | always loaded, advisory |
| applies to some paths or one language | `.claude/rules/*.md` with `paths:` | loads only when matching files are touched |
| is a workflow used now and then | a skill | loads on trigger, costs one description line otherwise |
| must hold every single time | a hook | prose gets reasoned away under pressure; a hook blocks |

Move a rule up this table when it fails: a `CLAUDE.md` line the agent ignored twice under
pressure becomes a hook. A procedure pasted into chat for the third time becomes a skill.

## What earns a line

Keep a line when leaving it out would cause a mistake:

- exact build, test and lint commands with their flags
- where things live, when the layout is not obvious
- conventions that differ from the framework default
- what never to touch, and branch or commit rules

Cut what the agent finds by reading the code, what it already knows about the language,
API documentation (link it), file-by-file tours, and facts that change weekly.

Test a `CLAUDE.md` change like a skill change: run a scenario without the line, then with
it, then with pressure ("just ship it"). If it holds without pressure and breaks with it,
it is a hook candidate. A quick health check for the whole file: ask the agent for the
test command. If it cannot answer, the file is too long to be read.

## Bridging AGENTS.md

Claude Code reads `CLAUDE.md`, not `AGENTS.md`. When other agents read `AGENTS.md` and both
should share one source, make the first line of `CLAUDE.md` an import:

```markdown
@AGENTS.md

## Claude only
Hooks, slash commands, anything other agents do not use.
```

The import keeps one source of truth and works on every platform, unlike a symlink.

## The Gates section

A `## Gates` section lists the checks a change must pass before it counts as done. Any
agent or script that finishes work in the repo runs them. The convention:

- One shell command per line, in a code block, run exactly as written.
- Placeholders in angle brackets are filled from the diff: `<changed-tests>` becomes the
  test files the change touched, `<changed-files>` the changed paths.
- A placeholder that resolves to nothing means the line does not apply. Skip it; do not
  run the command without arguments.
- A line starting with `merge-only:` runs once, on the final tree before merging, not
  after every intermediate change.
- No `## Gates` section means no gates are defined. Report that; do not invent checks.

````markdown
## Gates
```sh
npm run lint
npm run typecheck
npx vitest run <changed-tests>
merge-only: npm run test:e2e
```
````

Gates are still advisory text. A gate that must never be skipped also belongs in a hook or
in CI.
