#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

errors=()

if [[ $COMMAND =~ (^|[^a-zA-Z0-9_])find([^a-zA-Z0-9_]|$) ]]; then
  errors+=("Use 'fd' instead of 'find'")
fi

if [[ $COMMAND =~ (^|[^a-zA-Z0-9_])grep([^a-zA-Z0-9_]|$) ]]; then
  errors+=("Use 'rg' instead of 'grep'")
fi

if [[ ${#errors[@]} -gt 0 ]]; then
  printf -v msg '%s; ' "${errors[@]}"
  echo "DENIED: ${msg%; }" >&2
  exit 2
fi

exit 0
