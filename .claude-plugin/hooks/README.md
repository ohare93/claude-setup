# Shell Script Hooks

Executable hooks that integrate with Claude Code's hook system. Unlike markdown hooks (in `/hooks/`), these are shell scripts that can inspect, modify, or block tool calls.

## Available Hooks

### stop.sh

**Type:** Stop hook
**Purpose:** Display token usage and cost in status line

Runs when a session ends and outputs context/cache/cost information formatted for the status line.

**Installation:** Already wired via marketplace - no manual setup needed.

### prefer-modern-tools.sh

**Type:** PreToolUse hook (Bash matcher)
**Purpose:** Block `grep` and `find` in favor of `rg` and `fd`

Intercepts Bash commands before execution and denies any containing `grep` or `find`, displaying a message to use modern alternatives instead.

**Installation:** Add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "/home/jmo/Development/claude-setup/.claude-plugin/hooks/prefer-modern-tools.sh"
          }
        ]
      }
    ]
  }
}
```

**Behavior:**
- `grep foo file.txt` → DENIED: Use 'rg' (ripgrep) instead
- `find . -name "*.js"` → DENIED: Use 'fd' instead
- `ls -la` → Allowed
- `cat file | grep pattern` → DENIED (blocks grep even in pipes)

## How PreToolUse Hooks Work

1. Claude calls a tool (e.g., Bash)
2. Hook receives JSON on stdin: `{"tool_name": "Bash", "tool_input": {"command": "..."}}`
3. Script inspects and decides:
   - Exit 0 → Allow execution
   - Exit 2 → Block with error message (stderr shown to Claude)

## Creating New Hooks

```bash
#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Your validation logic here
if [[ some_condition ]]; then
  echo "Error message" >&2
  exit 2
fi

exit 0
```
