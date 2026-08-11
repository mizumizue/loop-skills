#!/usr/bin/env bash
# Link this repo's skills into Cursor discovery paths.
#
# Usage:
#   ./scripts/link-skills.sh [-f]                    # ~/.cursor/skills (personal)
#   ./scripts/link-skills.sh [-f] ~/.cursor          # same
#   ./scripts/link-skills.sh [-f] /path/to/workspace # <workspace>/.cursor/skills
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
force=0

usage() {
  cat <<'EOF'
Usage: link-skills.sh [-f] [target]

  target  omit            → ~/.cursor/skills
          ~/.cursor       → ~/.cursor/skills
          /path/to/ws     → /path/to/ws/.cursor/skills

  -f      replace existing directories without prompting
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--force) force=1; shift ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "unknown option: $1" >&2; usage >&2; exit 1 ;;
    *) break ;;
  esac
done

resolve_skills_dir() {
  local dest="${1:-}"
  if [[ -z "$dest" ]]; then
    echo "$HOME/.cursor/skills"
    return
  fi
  if [[ -d "$dest" ]]; then
    dest="$(cd "$dest" && pwd)"
  fi
  case "$dest" in
    */.cursor/skills) echo "$dest" ;;
    */.cursor) echo "$dest/skills" ;;
    *) echo "$dest/.cursor/skills" ;;
  esac
}

dir="$(resolve_skills_dir "${1:-}")"
mkdir -p "$dir"

declare -A map=(
  [author-loop-skill]=skills/meta/author-loop-skill
  [author-loop-workflow]=skills/meta/author-loop-workflow
  [loop-engineering]=skills/runtime/loop-engineering
  [loop-workflow]=skills/runtime/loop-workflow
  [sector-research-loop]=skills/work/sector-research-loop
  [spec-depth-loop]=skills/work/spec-depth-loop
  [mock-design-loop]=skills/work/mock-design-loop
  [demo-app-loop-workflow]=skills/work/demo-app-loop-workflow
)

echo "install target: $dir"
for name in "${!map[@]}"; do
  target="$root/${map[$name]}"
  link="$dir/$name"
  if [[ ! -e "$target" ]]; then
    echo "missing $target" >&2
    continue
  fi
  if [[ -e "$link" || -L "$link" ]]; then
    if [[ -L "$link" ]]; then
      rm -f "$link"
    elif [[ -d "$link" ]]; then
      if [[ "$force" -eq 1 ]]; then
        rm -rf "$link"
      else
        printf 'replace directory %s with symlink? [y/N] ' "$link" >&2
        read -r ans </dev/tty || ans=n
        case "$ans" in
          y|Y|yes|YES) rm -rf "$link" ;;
          *) echo "skip $name"; continue ;;
        esac
      fi
    else
      rm -f "$link"
    fi
  fi
  ln -s "$target" "$link"
  echo "linked $name -> ${map[$name]}"
done
