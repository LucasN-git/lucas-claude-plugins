#!/bin/bash
# PreToolUse hook (matcher Bash) for Claude Code. It reads the shell command before it
# runs and denies the two git mistakes that are expensive to undo: a push that would land
# on the production branch, and a blanket stage (git add -A, git add ., git add -u, ...)
# that commits files nobody looked at. Everything else passes through untouched.
#
# It answers with a deny decision in JSON and always exits 0. Without jq or python3 it
# cannot read the command and lets everything through (fails open).

PROD_BRANCH="__PROD_BRANCH__"
case "$PROD_BRANCH" in __PROD_BRANCH__) PROD_BRANCH="main" ;; esac

input=$(cat)

if command -v jq >/dev/null 2>&1; then
  cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
  cwd=$(printf '%s' "$input" | jq -r '.cwd // ""')
elif command -v python3 >/dev/null 2>&1; then
  cmd=$(printf '%s' "$input" | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("tool_input",{}).get("command",""))')
  cwd=$(printf '%s' "$input" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("cwd",""))')
else
  exit 0
fi
[ -n "$cmd" ] || exit 0

deny() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$1"
  exit 0
}

current_branch() {
  if [ -n "$cwd" ] && [ -d "$cwd" ]; then
    git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null
  else
    git rev-parse --abbrev-ref HEAD 2>/dev/null
  fi
}

# Reduce a refspec (+src:dst, HEAD:main, refs/heads/main, :main) to its target branch.
target_of() {
  t=${1##*:}
  t=${t#+}
  t=${t#refs/heads/}
  printf '%s' "$t"
}

# Quotes hide nothing from git, so they hide nothing from the guard either.
plain=$(printf '%s' "$cmd" | tr -d '"'"'")
# One segment per shell command: split on ; & | and newlines (this also splits && and ||).
segments=$(printf '%s' "$plain" | tr ';&|\n' '\n\n\n\n')

while IFS= read -r seg; do
  # shellcheck disable=SC2086
  set -- $seg
  [ $# -gt 0 ] || continue

  # Walk to the first "git" word, then to its subcommand, skipping options with or
  # without a separate value (-C dir, --git-dir=x, -c key=val, --no-pager ...).
  while [ $# -gt 0 ] && [ "$1" != "git" ]; do shift; done
  [ $# -gt 0 ] || continue
  shift
  while [ $# -gt 0 ]; do
    case "$1" in
      -C|-c|--git-dir|--work-tree|--namespace|--exec-path) shift 2 ;;
      -*) shift ;;
      *) break ;;
    esac
  done
  [ $# -gt 0 ] || continue
  sub=$1
  shift

  case "$sub" in
    add)
      for a in "$@"; do
        case "$a" in
          -A|--all|-u|--update|--no-ignore-removal|-A*|.|./|'*'|:/|:/*|'./*')
            deny "Blanket staging (git add $a) is blocked. Stage the files of this change by path, so nothing unrelated is committed." ;;
        esac
      done
      ;;
    push)
      remote=""
      targets=""
      for a in "$@"; do
        case "$a" in
          --repo=*) remote=${a#--repo=} ;;
          -*) continue ;;
          *)
            if [ -z "$remote" ]; then remote=$a
            else targets="$targets $(target_of "$a")"
            fi ;;
        esac
      done
      [ -n "$targets" ] || targets=$(current_branch)
      for t in $targets; do
        if [ "$t" = "$PROD_BRANCH" ]; then
          deny "Pushing to '$PROD_BRANCH' is blocked. Finished work stays local until the user says to go live, and then the user triggers the push."
        fi
      done
      ;;
  esac
done <<EOF
$segments
EOF

exit 0

# Local tests (substitute the branch first, then pipe sample stdin through it):
#   sed 's/__PROD_BRANCH__/main/' scripts/guard-git.sh > /tmp/g.sh && chmod +x /tmp/g.sh
#   t() { printf '%-42s -> ' "$1"; r=$(printf '{"tool_input":{"command":%s},"cwd":"/tmp"}' "$(printf '%s' "$1" | jq -Rs .)" | /tmp/g.sh); [ -n "$r" ] && echo deny || echo allow; }
#   t 'git push origin main'; t 'git push origin feature/x'; t 'git -C /x push origin HEAD:main'
#   t 'git push origin "main"'; t 'git add -A'; t 'git add "."'; t 'git add src/a.ts'; t 'git add -u'
