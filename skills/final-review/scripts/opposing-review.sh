#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <from-codex|from-claude> [extra-review-instructions]" >&2
  exit 2
fi

origin="$1"
shift || true

extra_instructions="${*:-}"
base_prompt=$'Review the current uncommitted changes adversarially.\n\nFocus on:\n- bugs and behavioral regressions\n- security issues\n- missing or weak tests\n- incorrect assumptions\n- unnecessary complexity\n\nReport findings first, ordered by severity, with file and line references when possible.\nDo not make edits.'

if [[ -n "$extra_instructions" ]]; then
  review_prompt="${base_prompt}"$'\n\nAdditional instructions:\n'"${extra_instructions}"
else
  review_prompt="${base_prompt}"
fi

case "$origin" in
  from-codex)
    if ! command -v claude >/dev/null 2>&1; then
      echo "claude CLI not found" >&2
      exit 127
    fi

    exec claude -p --print --tools Bash,Read --permission-mode default "$review_prompt"
    ;;
  from-claude)
    if ! command -v codex >/dev/null 2>&1; then
      echo "codex CLI not found" >&2
      exit 127
    fi

    exec codex review --uncommitted "$review_prompt"
    ;;
  *)
    echo "unknown origin: $origin" >&2
    exit 2
    ;;
esac
