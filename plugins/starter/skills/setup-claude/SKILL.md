---
name: setup-claude
description: Use when setting up Claude Code on a machine or refreshing the shared framework (/starter:setup-claude)
disable-model-invocation: true
---

# Set up Claude Code

One pass that turns a fresh Claude Code install into a working setup: a global CLAUDE.md with
the framework rules, permissions and a git guard hook, the plugins and MCP servers the user's
stack needs, and an optional project CLAUDE.md.

Safe to run again. Everything written goes into sentinel blocks or is merged key by key,
everything installed is checked for first. User text outside the sentinels is never touched,
existing settings keys are never replaced.

## 1. Interview

One `AskUserQuestion` round, at most four questions, before anything is read or installed:

1. Language of the global CLAUDE.md: English or German.
2. Stack: vibe-coded web app (GitHub, Supabase, Vercel, Playwright) / Nuxt, Postgres, Docker
   on a VPS / Python CLI tool / custom.
3. Production branch name (`main`, `master`, `production`, other) and whether the rule against
   pushing to it alone should be backed by the git guard hook.
4. Optional MCP servers, Linear among them.

For "custom", ask afterwards which services they use, in one free-form question.

## 2. Preflight

Report before changing anything. Gather:

- `which gh supabase vercel node jq brew uv docker` (missing ones exit non-zero, that is the answer)
- whether `~/.claude/CLAUDE.md` and `~/.claude/settings.json` exist, and whether the CLAUDE.md
  already carries `<!-- starter:` sentinels
- `claude mcp list`
- `claude plugin marketplace list` and the installed plugins

Print one table: item, current state, planned action. On macOS without Homebrew, say so and
skip every brew step instead of installing Homebrew unasked.

## 3. CLIs and MCP servers

Read `references/stacks.md`, only the section of the chosen preset plus the shared base.

Ask before each `brew install` or `npm i -g`, one question per tool, naming what it is for. A
tool that is already there is left alone, including its version. For `jq`, say in the question
that the git guard hook of step 6 needs it. Add each MCP server with `--scope user`.

Then run `claude mcp list` again and note which servers report "Needs authentication". Those
finish through `/mcp` in an interactive session or `claude mcp login <name>`. This skill cannot
complete an OAuth round for the user, so it names them and moves on.

## 4. Plugins

The official marketplace registers itself on first interactive start. If it is missing:
`claude plugin marketplace add anthropics/claude-plugins-official`. Then
`claude plugin install skill-creator@claude-plugins-official`.

The marketplace this skill comes from should be registered too. Read `claude plugin marketplace
list` and `claude plugin list`. If a `starter` plugin is already installed from any
marketplace, keep that source and skip this step. Only when none is installed:
`claude plugin marketplace add LucasN-git/lucas-claude-plugins`, then
`claude plugin install starter@lucas-claude-plugins`. Never register a second source for the
same plugin.

## 5. Global CLAUDE.md

Blocks live in `references/claude-md-blocks.md`, English and German. Copy the chosen language
verbatim, sentinels included, in the order they appear there.

Merge into `~/.claude/CLAUDE.md`. If the file is missing, write it with all eight blocks.
Otherwise decide per block, one of the eight at a time:

- Its sentinel pair is in the file: replace what is between the two sentinel lines, keep the
  sentinels and their position.
- Its sentinel pair is absent: append that block at the end of the file, preceded by one
  blank line.

A file can therefore hold some blocks in place and gain the rest at the bottom. A user who
does not want a block keeps it as an empty sentinel pair, because deleting the pair brings the
block back on the next run.

Text outside a sentinel pair is never edited, reordered or reformatted, however much it
overlaps with a block. Overlap is reported at the end, not resolved.

## 6. settings.json

Merge into `~/.claude/settings.json`. Read it first, keep every existing key and every existing
entry in an array. `jq` is the safe path, a careful Read and Edit works too. Before the first
change, copy the file to `settings.json.bak-<YYYYMMDD-HHMMSS>` next to it, so a second run
does not overwrite the backup of the first.

Add to `permissions.allow` the read-only commands that otherwise prompt all day:
`Bash(git status:*)`, `Bash(git diff:*)`, `Bash(git log:*)`, `Bash(git show:*)`,
`Bash(git branch:*)`, `Bash(gh pr view:*)`, `Bash(gh pr list:*)`, `Bash(ls:*)`,
`Bash(which:*)`. Skip the ones already present. `cat` is deliberately not on the list: it
reads `.env` files and key files as readily as source.

If the user wanted the production rule enforced, install the hook. Permission patterns only
match a command prefix, so they cannot single out the branch; the hook is the one net.

Install the hook:

1. `mkdir -p ~/.claude/hooks`
2. If `~/.claude/hooks/guard-git.sh` exists and its content differs from the version about to
   be written, show the difference and ask before overwriting. An identical file is left alone.
3. Substitute the branch while copying:
   `sed 's/__PROD_BRANCH__/<branch>/' <skill dir>/scripts/guard-git.sh > ~/.claude/hooks/guard-git.sh`
4. `chmod +x ~/.claude/hooks/guard-git.sh`
5. Check whether a `hooks.PreToolUse` entry already runs `guard-git.sh`. If one does, skip the
   registration, so a repeat run does not add the hook a second time.
6. Otherwise register it under `hooks.PreToolUse` with matcher `Bash` and command
   `~/.claude/hooks/guard-git.sh`, appending to the existing matcher entry rather than
   replacing the array.

The hook speaks through JSON and exits 0, so a bug in it fails open. It parses the tool input
with `jq`, falls back to `python3`, and lets every command through when neither exists. That
is why `jq` belongs to the shared base install and is not one of the optional tools. Say this
in the report.

The hook denies a push that would land on the production branch, including
`git push origin HEAD:<branch>` and a forced push, and denies `git add -A` and `git add .`. It
lets every other branch through. Hooks load at session start, so it takes effect after a
restart.

## 7. Memory

Auto-memory is on unless `autoMemoryEnabled` is `false` in settings.json. Check, report, and
change it only if the user asks. Nothing needs to be created.

## 8. Project starter

If the current directory is a repository without a `CLAUDE.md`, offer the template in
`references/project-claude-md.md`. On yes, write it with the slots filled from what the repo
actually shows: package manager and scripts from the manifest, production branch from the
answer in step 1, deploy path from the CI config if there is one. A slot with no evidence stays
an angle-bracket placeholder rather than becoming a guess.

## 9. Report

One table: item, action (installed, written, merged, skipped), reason for each skip. Below it,
the steps only the user can do:

- `gh auth login` and any other CLI login that is still open
- `/mcp` or `claude mcp login <name>` for each server that needs authentication
- restart Claude Code so plugins, hooks and the new CLAUDE.md load

No summary of what the setup is for. The table and the open steps are the whole report.
