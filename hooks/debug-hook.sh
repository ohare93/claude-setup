#!/usr/bin/env bash
# Minimal debug hook: logs every invocation with event name, env, and stdin.
set -u

STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/claude-debug"
LOG="$STATE_DIR/debug.log"
mkdir -p "$STATE_DIR"

EVENT="${1:-UNKNOWN}"
TS="$(date '+%Y-%m-%d %H:%M:%S')"

STDIN_DATA="$(timeout 1 cat 2>/dev/null || echo '<no-stdin>')"

{
    echo "===== $TS event=$EVENT pid=$$ ppid=$PPID ====="
    echo "KITTY_PID=${KITTY_PID:-<unset>}"
    echo "CLAUDE_PLUGIN_ROOT=${CLAUDE_PLUGIN_ROOT:-<unset>}"
    echo "PWD=$PWD"
    echo "stdin: $STDIN_DATA"
    echo ""
} >> "$LOG"

exit 0
