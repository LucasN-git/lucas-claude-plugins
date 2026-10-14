---
name: writing-skills
description: Use when writing or fixing a skill, subagent, CLAUDE.md, or deciding whether a rule belongs in a hook
---

# Writing skills

Covers every file an agent reads as instructions: skills, subagents, `CLAUDE.md`, and
whether a rule should be prose at all. This skill decides what to write and what to leave
out; `skill-creator@claude-plugins-official` handles drafting, evals and description tuning.

## The loop

1. **Baseline.** Run the real task without the skill and watch what goes wrong. Keep the
   wrong output and the agent's excuses in its own words.
2. **Minimal fix.** Write only what addresses the observed failures. Instruction following
   decays as rules pile up, so a line that changes no behavior taxes the lines around it.
3. **Close the loopholes.** Re-run. When the agent obeys the letter and misses the point,
   name the workaround it invented and forbid it by name.

**No content that changes behavior without a failing baseline first.** This covers new
skills and every edit that adds or changes guidance. A draft written before the baseline
gets deleted, not kept "for reference" and not relabeled a small doc update. Two kinds of
edit are exempt. Mechanical edits: typos, formatting, a table of contents, pure
reordering. Behavior-preserving cleanup of a skill that still works: deduplication,
shortening, moving text behind a gate. Prove the cleanup kept behavior by re-running the
existing scenarios. Once a cleanup changes what the skill teaches, it needs a baseline.

**Editing an existing file: no net growth by default.** Run `scripts/size-budget.sh <dir>
> before.txt` before touching anything, and `scripts/size-budget.sh <dir> --baseline
before.txt` after. Pay for an addition by cutting elsewhere; moving text into a reference
does not pay, the budget counts every `.md` file. If growth is right, state it before
editing (`--max-growth 400`), never after. Hand the diff to a reviewer subagent: first
drafts come out too long and too tied to the one incident.

## Name and description

The description is read every turn, for every installed skill, to decide what to load.
Forty skills at 250 characters each is several thousand tokens on every turn. The body
costs nothing until it loads. Spend characters in the body, not here.

Recipe: one line, `Use when <triggers or symptoms>`, no trailing period, usually under 120
characters. State WHEN, never HOW. A description that summarizes the workflow becomes a
shortcut the agent follows instead of reading the body.

```yaml
# Bad: summarizes the process
description: Use when reviewing a diff - read the files, rank findings, then post a verdict

# Good: triggers only
description: Use when about to report a change as done, or on "review my changes"
```

Each addition has to be earned by a failure you saw:

- **Capability clause** ("for X"): only to separate the skill from a named sibling the
  agent actually confuses it with.
- **"Not for …"**: a last resort after observed over-triggering on a specific sibling.
  First try to fold the distinction into the trigger itself.
- **Keywords**: only tokens the model cannot infer (a slash command, an error string, a
  file extension), and only when the skill fails to load. Paraphrases already match.

Under-triggering is usually vocabulary, not length: describe the symptom the user types.

Hard limits: `name` lowercase letters, digits and hyphens, at most 64 characters;
`description` non-empty, at most 1024 characters, no angle brackets. 1024 is a ceiling,
not a target.

Naming: verb-first for skills that do something (`reviewing-diffs`,
`condition-based-waiting`), a noun for references (`api-errors`). Never `helper`, `utils`
or `misc`; a name that fits anything triggers on nothing.

For a workflow the user always starts by name, set `disable-model-invocation: true`. It
keeps `/name` working and removes the per-turn cost.

## Progressive disclosure

Three tiers: metadata (always loaded), body (loaded on match), files in `references/`
(zero cost until read). Aim for 150 body lines and stop at 200; past that, split. A fact
lives in the body or in a reference, never both.

Gate every reference with a predicate: "Read references/forms.md only when the task
involves filling a PDF form". An ungated "see X for details" gets read every run. Link
each reference directly from the body, one level deep; a reference that points to another
reference gets read partially. Give any reference over 100 lines a table of contents.

## Altitude

Describe the destination, not the route; prescribe steps only where the ground is fragile.

| Freedom | When | Form |
|---|---|---|
| High (default) | many valid paths, judgment depends on context | goal, constraints, what success looks like |
| Medium | a preferred pattern, variation acceptable | pseudocode or a script with parameters |
| Low | irreversible or order-sensitive, consistency matters | exact commands: "run this, do not modify" |

At any altitude, keep what the model cannot infer: exact flags, paths, units, domain
meanings, stopping conditions, safety limits, and why the goal matters.

Calibrate to the weakest model that will run the skill. A detail you cut because a strong
model infers it is a failure on a smaller one. When the target model gets stronger, run a
deletion pass.

Delete rather than soften what the model already does unprompted ("think step by step",
"be thorough"). State each rule once; repetition over-triggers, and two versions that
disagree cost more than none. Save capitals and "CRITICAL" for invariants a baseline
proved an agent breaks under pressure.

## Match the form to the failure

Classify the baseline failure before writing. The form that fixes one type backfires on
another.

| Baseline failure | Right form |
|---|---|
| Knows the rule, skips it under pressure | Prohibition, a table of excuses with rebuttals, red flags |
| Complies, but the output has the wrong shape | Positive recipe: what the output is, its parts, in order |
| Leaves out a required element | A required slot in the template it already fills |
| Behavior should depend on a condition | A conditional keyed to something observable |

Excuse tables and red-flag lists belong to discipline skills only (the first row).

Prohibitions backfire on shaping problems. An agent with a competing incentive negotiates
with "don't X" and, in wording tests, produced more of the unwanted content than with no
guidance at all. A recipe leaves nothing to negotiate. Avoid nuance clauses ("unless it
matters"); turn a real exception into its own conditional. State the rule for the whole
class of failure, not the one incident.

## Testing

Have at least three distinct scenarios before calling a file done, each run with and
without the skill. Check the weakest model you deploy on (missing detail shows) and the
strongest (over-explaining shows).

Before full scenarios, micro-test the wording:

- One fresh context per sample, with the realistic surrounding prompt and a task that
  tempts the failure.
- Always a control run without the guidance. If the control does not fail, write nothing.
- Five or more repetitions per variant; one sample lies.
- Read every match by hand. Echoes of the template look like hits.
- Treat variance as a signal. Binding wording makes the runs converge; five different
  readings mean the form is wrong, and more words will not fix it.

Read `references/testing.md` only when writing pressure scenarios for a discipline skill
or setting up a micro-test harness.

## Content

- One complete example from a real case beats several sketches.
- One default with one escape hatch, not a menu of options.
- No war stories and nothing dated. The file describes how things are.
- Order-sensitive process: the skill emits a checklist the agent copies and ticks off.
- Scripts: say whether to run or read them, handle errors inside the script, explain each
  magic number, list required packages, and audit any bundled script before sharing.

Read https://docs.claude.com/en/docs/agents-and-tools/agent-skills/best-practices only
when a question about skill structure is not answered here.

## Subagents

A subagent starts cold. Its description carries the whole delegation decision, and its
body gathers its own context ("run `git diff` first").

- Set `model` explicitly in any committed agent, never `inherit`: the agent then runs on
  whatever the caller happens to use, including the most expensive model.
- Omitting `tools` inherits everything, MCP servers included. Give a minimal allowlist
  and scope Bash by subcommand: `Bash(git diff:*)`, not bare `Bash`.
- Agents shipped in a plugin ignore `hooks`, `mcpServers` and `permissionMode` in their
  frontmatter. Enforcement for them lives in the plugin's own hooks.
- Prefer a skill. Use a subagent for context isolation, enforced tool limits, a pinned
  model, or parallel work.

Read `references/subagents.md` only when writing or auditing an agent file.

## CLAUDE.md

`CLAUDE.md` is advisory. Anything that must hold every time is a `PreToolUse` hook that
blocks, not a sentence an agent can reason around: a push to production, `git add -A`, a
write to a read-only host. Keep each file under about 200 lines; bloat hides the real
rules. Cut what the code already says, what Claude already knows, and what changes weekly.

Read `references/claude-md.md` only when deciding where an instruction belongs, bridging
`AGENTS.md`, or adding a `## Gates` section.

## Prose

Read `references/prose-tells.md` before writing prose longer than a checklist item into
these files, and before a skill's output goes to a human.

## Checklist

- [ ] Failing baseline recorded, or the edit is mechanical or behavior-preserving
- [ ] Guidance form matches the failure type
- [ ] `description` one `Use when` line, no trailing period, no workflow summary
- [ ] Body under 200 lines; references gated with a predicate, one level deep
- [ ] `size-budget.sh` PASS against the baseline, or the budget was stated up front
- [ ] Three or more scenarios, run with and without
- [ ] Prose checked against `references/prose-tells.md`
