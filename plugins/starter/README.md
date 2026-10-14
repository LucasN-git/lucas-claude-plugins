# starter

A compact Claude Code setup for building apps. Six skills that carry a way of working, not a
stack: which model reviews what, when work counts as done, what never goes to production on
its own, and how instructions for the agent are written.

## Install

```bash
claude plugin marketplace add LucasN-git/lucas-claude-plugins
claude plugin install starter@lucas-claude-plugins
```

Then, inside Claude Code:

```
/starter:setup-claude
```

The setup skill interviews you once (language, stack, production branch), installs the missing
CLIs and MCP servers for your stack, registers the official `skill-creator` plugin, writes the
framework blocks into `~/.claude/CLAUDE.md`, adds a permissions allowlist and a git guard hook to
`~/.claude/settings.json`, and offers a project `CLAUDE.md` template for the repo you are in. A
second run refreshes the framework blocks (it touches only text inside its sentinel markers),
skips what is already installed, and asks before overwriting anything else.

## Skills

| Skill | Use |
|---|---|
| `setup-claude` | One-shot onboarding of a machine. Re-run to refresh the framework blocks. |
| `quick-review` | One cheap review pass over the current diff before reporting a change as done. |
| `review` | The heavier tier: a few reviewer agents sized by the diff (one to three, plus one fixer), the coordinator filters, one fix round, an HTML report. Runs the project's `## Gates` before and after. |
| `html-output` | Renders a substantial deliverable (plan, review, report, comparison) as one self-contained HTML page in the browser. |
| `writing-skills` | The craft of writing skills, subagents, CLAUDE.md files and hooks, including a prose checklist that keeps the text free of AI tells. Complements the official `skill-creator`, which drafts, runs evals and tunes descriptions. |
| `remove-ai-tells` | Strips the generated look from pages and copy: subtitle stacks, card grids, gradients, marketing filler. It applies the fixes; a bare list of findings counts as a failed run. The `dev` plugin relies on this one. |

## The framework in `~/.claude/CLAUDE.md`

The global file describes how to work; a project's own `CLAUDE.md` carries the facts of that
repo. The global blocks, each wrapped in `<!-- starter:<name> -->` sentinels:

- **agents**: subagents run on a different model than the coordinator; small model to find and
  report, big model to judge and change; several agents with different perspectives beat one long
  one.
- **finishing**: a change is done after a review pass and, for UI, a walk-through in a real
  browser.
- **git**: finished work lands in local main unpushed; production only on an explicit command.
- **docs**: docs change in the same commit, written as current state.
- **foreign-systems**: what the app does not own is read-only, enforced technically.
- **style**: concept before implementation, bullets over prose, no preamble or recap.
- **memory**: one fact per file plus an index.
- **skills**: when to reach for the skills above.

Rules that must hold every time are hooks, not sentences. The setup skill installs one:
`~/.claude/hooks/guard-git.sh` blocks `git push` to the production branch (any refspec, quoted
or not, also via `git -C`) and blanket staging (`git add -A`, `.`, `-u`, `:/`). It needs `jq` or
`python3`; without both it lets everything through. Its test cases sit as a comment at the end
of `skills/setup-claude/scripts/guard-git.sh`.

## Gates

A project names its checks in a `## Gates` section of its `CLAUDE.md`: one shell command per
line in a code block, run exactly as written; `<changed-tests>` is filled from the diff, an empty placeholder
means not applicable; a `merge-only:` line runs once on the final tree. `review` runs them
before the reviewers start and again after the fixer. No section means no gates defined, and
the report says so.

## Layout

```
.claude-plugin/plugin.json
agents/review-*.md
skills/<name>/SKILL.md [+ references/, scripts/]
```

A change in a skill reaches an installed copy after a version bump in `.claude-plugin/plugin.json`
and the marketplace's `.claude-plugin/marketplace.json`, followed by
`claude plugin update starter@lucas-claude-plugins`.
