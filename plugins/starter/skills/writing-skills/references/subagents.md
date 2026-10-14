# Subagent files

1. [Frontmatter](#frontmatter)
2. [Scoping Bash](#scoping-bash)
3. [Template: a reviewer](#template-a-reviewer)

An agent file lives at `.claude/agents/<name>.md` in a project, `~/.claude/agents/` for
the user, or `agents/` inside a plugin. A changed file takes effect after a session
restart.

## Frontmatter

| Field | Required | What it does |
| --- | --- | --- |
| `name` | yes | Lowercase letters, digits, hyphens. The identity; the file name does not count. Two agents with one name in one scope: one silently disappears |
| `description` | yes | The only thing the caller sees when deciding to delegate. A `Use when` line plus what comes back. Triggers, not mechanics |
| `tools` | no | Comma-separated allowlist. Left out, the agent inherits every tool of the caller, MCP servers included. Always set it in a committed agent |
| `disallowedTools` | no | Denylist applied on top of what is inherited or allowed. Useful to remove one tool from an otherwise inherited set; an allowlist is still the safer default |
| `model` | no | `sonnet`, `opus`, `haiku` or `inherit`. Set it explicitly: `inherit` ties cost and behavior to whatever the caller runs on |
| `color` | no | Display color in the interface. No effect on behavior |
| `skills` | no | Skills preloaded into the agent's context at start. Each one costs its full body on every run, so list only what every run needs |
| `maxTurns` | no | Upper bound on agentic turns. Stops a stuck agent from looping; set it for agents that search or retry |

Plugin agents ignore `hooks`, `mcpServers` and `permissionMode`. If a plugin agent needs
a guard, put the hook in the plugin's `hooks/hooks.json`.

## Scoping Bash

Bare `Bash` lets the agent run anything. Grant subcommands instead:

```yaml
tools: Read, Grep, Glob, Bash(git diff:*), Bash(git log:*), Bash(git show:*)
```

- A read-only agent gets no `Write`, `Edit` or `NotebookEdit`; it cannot change files
  even if its prompt tells it to.
- A fixing agent adds `Edit` plus exactly the commands it runs (`Bash(npm test:*)`).
- MCP tools are excluded once `tools` is set, unless listed by full name
  (`mcp__server__tool`).
- When the allowlist cannot express the rule (allow `psql`, but only reads), add a
  `PreToolUse` hook that inspects the command and exits 2 to block.

## Template: a reviewer

```markdown
---
name: migration-reviewer
description: Use when a diff adds or changes database migrations, before merge. Returns risks, not fixes
tools: Read, Grep, Glob, Bash(git diff:*), Bash(git log:*)
model: sonnet
color: orange
maxTurns: 30
---

You review database migrations in the current branch. You have no conversation
history; collect your own context.

## When invoked
1. Run `git diff --name-only main...HEAD` and keep the migration files.
2. Read each migration and the schema or model files it touches.

## Look for
- Destructive steps (drop, rename, type narrowing) without a backfill or a two-step plan.
- Locks on large tables: new indexes built without a concurrent option, defaults that
  rewrite every row.
- A migration that cannot be rolled back, with no note saying so.

## Output
One line per finding: `file:line | risk | what would break`.
Last line: `VERDICT: SAFE` or `VERDICT: RISKS FOUND`. Do not edit files.
```

Why each part is there:

- `description` names the trigger and the deliverable. "Returns risks, not fixes" keeps
  the caller from expecting a patch.
- `tools` is read-only plus two git subcommands. The agent cannot write even if asked.
- `model: sonnet` is pinned: the work is reading and judging, and the cost stays fixed.
- `maxTurns` caps a search that never converges.
- "When invoked" is numbered because the agent starts cold and must gather context in
  order.
- "Look for" defines what a finding is. Without it, reviewers report style.
- "Output" is a fixed shape the caller can parse, ending in a one-word verdict.
