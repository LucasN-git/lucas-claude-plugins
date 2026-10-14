# Stack presets

Read only the section of the preset the user picked. Every install step is offered to the
user before it runs. Every MCP server is added with `--scope user` so it is available in all
projects. OAuth cannot be completed by the skill, the user does it later with `/mcp` or
`claude mcp login <name>`.

Shared base, added for every preset:

| tool | check | install | auth | MCP add command |
|---|---|---|---|---|
| node | `which node` | `brew install node` | none | none |
| jq | `which jq`, required by the git guard hook | `brew install jq` | none | none |
| gh | `which gh` | `brew install gh` | `gh auth login` | none |

## Preset: vibe-coded web app (GitHub, Supabase, Vercel, Playwright)

| tool | check | install | auth | MCP add command |
|---|---|---|---|---|
| supabase | `which supabase` | `brew install supabase/tap/supabase` | `supabase login` | `claude mcp add --transport http supabase https://mcp.supabase.com/mcp --scope user` |
| vercel | `which vercel` | `npm i -g vercel` | `vercel login` | `claude mcp add --transport http vercel https://mcp.vercel.com --scope user` |
| playwright | none, runs via npx | none | none | `claude mcp add --transport stdio playwright --scope user -- npx @playwright/mcp@latest` |
| playwright-cli | `npm install -g @playwright/cli` | `playwright-cli --version` | `npm install -g @playwright/cli@latest` | none; `starter:playwright-cli` drives it from the shell |

Supabase and Vercel both need an OAuth round in the browser before their tools answer.

## Preset: Nuxt, Postgres, Docker on a VPS

| tool | check | install | auth | MCP add command |
|---|---|---|---|---|
| docker | `which docker` | `brew install --cask docker-desktop` | none, start the app once | none |
| ssh | `which ssh` | preinstalled on macOS | key in `~/.ssh/config` for the VPS host | none |
| playwright | none, runs via npx | none | none | `claude mcp add --transport stdio playwright --scope user -- npx @playwright/mcp@latest` |
| playwright-cli | `npm install -g @playwright/cli` | `playwright-cli --version` | `npm install -g @playwright/cli@latest` | none; `starter:playwright-cli` drives it from the shell |

The database lives on the VPS, so there is no database MCP server. Access goes through ssh
and the project's own commands, and the read-only rule for foreign systems applies.

## Preset: Python CLI tool

| tool | check | install | auth | MCP add command |
|---|---|---|---|---|
| uv | `which uv` | `brew install uv` | none | none |

No browser tooling. A CLI is verified by running it, not by a browser walk-through, so the
UI clause of the finishing rule does not apply here.

## Preset: custom

Ask the user to name their services. Map each one:

- The service publishes an MCP endpoint: `claude mcp add --transport http <name> <url> --scope user`.
- The service ships a local MCP server: `claude mcp add --transport stdio <name> --scope user -- <command>`, the `--` is required and every flag for the server goes after it.
- The service only has a CLI: check with `which`, install with the vendor's documented command, note the auth command in the final report.

Invent neither an endpoint URL nor a brew formula. An unknown one is asked for or left out.

## Optional, any preset

| tool | MCP add command | note |
|---|---|---|
| Linear | `claude mcp add --transport http linear https://mcp.linear.app/mcp --scope user` | issue tracking, needs OAuth |

## Verifying

`claude mcp list` prints each server as Connected, Needs authentication or Failed. Run it
after adding and carry the state into the final report. Needs authentication is the expected
state for a fresh OAuth server and not an error.
