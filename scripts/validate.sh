#!/usr/bin/env bash
set -euo pipefail

skill_dir="skills/ticket-context"
skill_file="$skill_dir/SKILL.md"

required_files=(
  "README.md"
  "$skill_file"
  "$skill_dir/PROMPT.md"
  "$skill_dir/examples/clarify-mode.md"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "missing: $file" >&2
    exit 1
  fi
done

if [[ $(sed -n '1p' "$skill_file") != "---" ]]; then
  echo "SKILL.md missing opening YAML frontmatter delimiter" >&2
  exit 1
fi

closing_delimiter_line=$(awk 'NR > 1 && $0 == "---" { print NR; exit }' "$skill_file")
if [[ -z "$closing_delimiter_line" ]]; then
  echo "SKILL.md missing closing YAML frontmatter delimiter" >&2
  exit 1
fi

frontmatter=$(sed -n "2,$((closing_delimiter_line - 1))p" "$skill_file")

if ! grep -q '^name: ticket-context$' <<< "$frontmatter"; then
  echo "SKILL.md missing name" >&2
  exit 1
fi

if ! grep -q '^description: .\+' <<< "$frontmatter"; then
  echo "SKILL.md missing description" >&2
  exit 1
fi

if find . -name .DS_Store -print -quit | grep -q .; then
  echo ".DS_Store files found" >&2
  exit 1
fi

echo "ok"
