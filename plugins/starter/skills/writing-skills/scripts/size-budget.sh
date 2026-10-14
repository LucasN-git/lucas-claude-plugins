#!/bin/sh
# Measures what a skill costs in context and checks an edit against a budget.
#
#   size-budget.sh <skill-dir>                         print the numbers
#   size-budget.sh <skill-dir> > before.txt            save them as a baseline
#   size-budget.sh <skill-dir> --baseline before.txt   compare; FAIL on any growth
#   size-budget.sh <skill-dir> --baseline before.txt --max-growth 400
#
# The baseline file is either this script's own output or a file holding one
# number (total .md chars). Only .md files count: scripts and assets cost no
# context until they run. Exit 0 = PASS, 1 = FAIL, 2 = usage error.
set -eu

LINE_CAP=200      # SKILL.md body length where splitting into references is due
DESC_CAP=1024     # hard limit on description length
NAME_CAP=64       # hard limit on name length

usage() { echo "usage: size-budget.sh <skill-dir> [--baseline FILE] [--max-growth N]" >&2; exit 2; }

[ $# -ge 1 ] || usage
dir=$1; shift
baseline_file=""; max_growth=0
while [ $# -gt 0 ]; do
  case $1 in
    --baseline)   [ $# -ge 2 ] || usage; baseline_file=$2; shift 2 ;;
    --max-growth) [ $# -ge 2 ] || usage; max_growth=$2; shift 2 ;;
    *)            usage ;;
  esac
done
case $max_growth in ''|*[!0-9]*) echo "error: --max-growth needs a whole number" >&2; exit 2 ;; esac

skill="$dir/SKILL.md"
[ -f "$skill" ] || { echo "error: no SKILL.md in $dir" >&2; exit 2; }

# Frontmatter value of a key; folds an indented block (">" or "|") into one line.
field() {
  awk -v key="$1" '
    NR == 1 && $0 == "---" { fm = 1; next }
    fm && $0 == "---" { exit }
    fm && grab && /^[ \t]/ { sub(/^[ \t]+/, ""); val = val (val == "" ? "" : " ") $0; next }
    fm && grab { exit }
    fm && index($0, key ":") == 1 {
      val = substr($0, length(key) + 2); sub(/^[ \t]+/, "", val)
      if (val == ">" || val == "|" || val == ">-" || val == "|-") { val = ""; grab = 1; next }
      exit
    }
    END { gsub(/^["\x27]|["\x27]$/, "", val); printf "%s", val }
  ' "$skill"
}

name=$(field name)
desc=$(field description)
skill_chars=$(wc -c < "$skill" | tr -d ' ')
skill_lines=$(wc -l < "$skill" | tr -d ' ')
desc_chars=$(printf '%s' "$desc" | wc -c | tr -d ' ')
total=$(find "$dir" -type f -name '*.md' -exec cat {} + | wc -c | tr -d ' ')

echo "skill_md_chars=$skill_chars"
echo "skill_md_lines=$skill_lines"
echo "description_chars=$desc_chars"
echo "total_md_chars=$total"

status=0
fail() { echo "FAIL: $*"; status=1; }

[ "$skill_lines" -le "$LINE_CAP" ] || fail "SKILL.md has $skill_lines lines, cap $LINE_CAP; move gated material into references/"
[ -n "$desc" ] || fail "description is empty"
[ "$desc_chars" -le "$DESC_CAP" ] || fail "description has $desc_chars chars, limit $DESC_CAP"
case $desc in *'<'*|*'>'*) fail "description contains an angle bracket" ;; esac
[ "${#name}" -le "$NAME_CAP" ] || fail "name has ${#name} chars, limit $NAME_CAP"

if [ -n "$baseline_file" ]; then
  [ -f "$baseline_file" ] || { echo "error: baseline file $baseline_file not found" >&2; exit 2; }
  base=$(sed -n 's/^total_md_chars=//p' "$baseline_file")
  [ -n "$base" ] || base=$(tr -d ' \n' < "$baseline_file")
  case $base in ''|*[!0-9]*) echo "error: no total in $baseline_file" >&2; exit 2 ;; esac
  delta=$((total - base))
  echo "delta_chars=$delta (baseline $base, allowed +$max_growth)"
  [ "$delta" -le "$max_growth" ] || fail "grew by $delta chars; cut elsewhere or state a budget before editing"
fi

[ "$status" -eq 0 ] && echo "PASS"
exit "$status"
