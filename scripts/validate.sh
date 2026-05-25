#!/usr/bin/env bash
set -euo pipefail

skill_dir="skills/ticket-context"

for file in \
  "README.md" \
  "$skill_dir/SKILL.md" \
  "$skill_dir/PROMPT.md" \
  "$skill_dir/examples/clarify-mode.md"; do
  test -f "$file" || { echo "missing: $file" >&2; exit 1; }
done

head -n 1 "$skill_dir/SKILL.md" | grep -qx -- '---' || { echo "SKILL.md missing YAML frontmatter" >&2; exit 1; }
grep -q '^name: ticket-context$' "$skill_dir/SKILL.md" || { echo "SKILL.md missing name" >&2; exit 1; }
grep -q '^description:' "$skill_dir/SKILL.md" || { echo "SKILL.md missing description" >&2; exit 1; }

if find . -name .DS_Store | grep -q .; then
  echo ".DS_Store files found" >&2
  exit 1
fi

echo "ok"
