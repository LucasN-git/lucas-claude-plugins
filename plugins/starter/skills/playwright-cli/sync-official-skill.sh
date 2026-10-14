#!/usr/bin/env bash
# Copies the agent skill that ships inside the @playwright/cli npm package (Microsoft,
# Apache-2.0) into this folder: the body of its SKILL.md and its references, verbatim.
# Only the frontmatter block at the top of our SKILL.md is ours and is kept.
# Run again after updating playwright-cli (npm install -g @playwright/cli@latest), or point
# PLAYWRIGHT_CLI_PKG at an unpacked "npm pack @playwright/cli" to vendor without installing.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skill="$here/SKILL.md"
src="${PLAYWRIGHT_CLI_PKG:-$(npm root -g)/@playwright/cli}/skills/playwright-cli"
[ -f "$src/SKILL.md" ] || { echo "no shipped skill at $src; run: npm install -g @playwright/cli@latest" >&2; exit 1; }
ver="$(node -p "require('${PLAYWRIGHT_CLI_PKG:-$(npm root -g)/@playwright/cli}/package.json').version" 2>/dev/null || echo unknown)"
if [ -f "$skill" ]; then
  fm="$(awk 'NR==1&&$0=="---"{f=1;print;next} f&&$0=="---"{print;exit} f{print}' "$skill")"
else
  fm=$'---\nname: playwright-cli\ndescription: Use when driving a website from the shell with the playwright-cli command: filling forms, clicking through a flow, taking screenshots, checking a web app, pulling data off a page\nallowed-tools: Bash(playwright-cli:*) Bash(npx:*) Bash(npm:*)\n---'
fi
body="$(awk 'c<2{if($0=="---")c++;next}{print}' "$src/SKILL.md")"
{
  printf '%s\n\n' "$fm"
  printf '<!-- Body and references vendored from the playwright-cli %s package (Microsoft, Apache-2.0). Not hand-edited: run ./sync-official-skill.sh to refresh. -->\n\n' "$ver"
  printf '%s\n' "$body"
} > "$skill"
rm -rf "$here/references"
[ -d "$src/references" ] && cp -R "$src/references" "$here/references"
echo "vendored playwright-cli skill from $ver: $(wc -l < "$skill" | tr -d ' ') lines, $(ls "$here/references" | wc -l | tr -d ' ') references"
