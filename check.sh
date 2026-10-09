#!/bin/sh
# SessionStart hook: list installed skills that which-skill/SKILL.md never mentions.
# Skill identity = directory name holding SKILL.md (that's the invoked name, not frontmatter `name:`).
# ponytail: only sees on-disk skills; built-ins and connector skills (vercel, artifact-*) are mapped by hand.
dir="$HOME/.claude/skills/which-skill"
map="$dir/SKILL.md"
{
  find -L "$HOME/.claude/skills" -mindepth 2 -maxdepth 4 -name SKILL.md 2>/dev/null
  jq -r '.plugins[][].installPath' "$HOME/.claude/plugins/installed_plugins.json" 2>/dev/null |
    while read -r p; do find "$p" -name SKILL.md 2>/dev/null; done
} | xargs -r -n1 dirname | xargs -r -n1 basename | sort -u |
  grep -vxF -e which-skill -e .staging -f "$dir/ignore.txt" |
  while read -r s; do grep -qE "/$s([^a-z0-9-]|\$)" "$map" || echo "$s"; done > "${TMPDIR:-/tmp}/which-skill-missing.$$"
if [ -s "${TMPDIR:-/tmp}/which-skill-missing.$$" ]; then
  echo "which-skill: estas skills instaladas no están en ~/.claude/skills/which-skill/SKILL.md."
  echo "Avisale al usuario en tu primera respuesta y proponé dónde ubicarlas (o agregarlas a ignore.txt):"
  sed 's/^/  - /' "${TMPDIR:-/tmp}/which-skill-missing.$$"
fi
rm -f "${TMPDIR:-/tmp}/which-skill-missing.$$"
exit 0
