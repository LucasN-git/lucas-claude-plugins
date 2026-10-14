# lucas-claude-plugins

A Claude Code marketplace with two plugins. `starter` carries a way of working: how a machine
is set up, which model reviews what, when a change counts as done, how instructions for the
agent are written. `dev` carries the standards for the apps built with it: shells for data
apps and consumer apps, interface states, charts.

## Install

```bash
claude plugin marketplace add LucasN-git/lucas-claude-plugins
claude plugin install starter@lucas-claude-plugins
claude plugin install dev@lucas-claude-plugins   # only if you build app UIs
```

Then, inside Claude Code, run `/starter:setup-claude` once. It interviews you (language, stack,
production branch), installs the missing CLIs and MCP servers, writes the framework blocks into
`~/.claude/CLAUDE.md` and adds a permissions allowlist plus a git guard hook.

## Plugins

| Plugin | Skills |
|---|---|
| `starter` | `setup-claude`, `quick-review`, `review` (with four reviewer and fixer agents), `html-output`, `writing-skills`, `remove-ai-tells` |
| `dev` | `app-blueprint`, `data-app-ui`, `desktop-shell`, `mobile-shell`, `good-ux`, `chart-design`, `data-storytelling` |

`dev` relies on `starter:remove-ai-tells`; install both from this marketplace. If you already
have a `starter` plugin from another marketplace, keep one of the two, not both, or the same
trigger fires two skills.

Each plugin has its own `README.md` with the skills explained.

## Updating

```bash
claude plugin marketplace update lucas-claude-plugins
claude plugin update starter@lucas-claude-plugins
claude plugin update dev@lucas-claude-plugins
```

Changes are listed in `CHANGELOG.md`.

## License

MIT, see `LICENSE`.
