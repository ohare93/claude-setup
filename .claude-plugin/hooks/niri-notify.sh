#!/usr/bin/env bash
# Niri window urgency hook for Claude Code
# Sets the terminal window as urgent when a session needs attention
#
# Usage: niri-notify.sh <notify|stop>
#   notify - Session needs input: set window urgent + desktop notification
#   stop   - Session finished: clear urgency

ACTION="${1:-notify}"
STATE_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/claude-niri"
KITTY_PID="${KITTY_PID:-}"

# Read hook JSON from stdin (timeout-guarded — hook runner may not close stdin)
HOOK_INPUT=$(timeout 1 cat 2>/dev/null || echo "{}")
PROJECT_DIR=$(echo "$HOOK_INPUT" | jq -r '.cwd // ""' 2>/dev/null || echo "")
PROJECT_NAME=$(basename "$PROJECT_DIR" 2>/dev/null || echo "")

has_niri() { [ -n "${NIRI_SOCKET:-}" ] && command -v niri >/dev/null 2>&1; }

find_window() {
    [ -z "$KITTY_PID" ] && return 1
    niri msg --json windows 2>/dev/null | \
        jq --argjson pid "$KITTY_PID" '.[] | select(.pid == $pid)' 2>/dev/null
}

get_window_id() {
    echo "$1" | jq -r '.id'
}

get_window_title() {
    echo "$1" | jq -r '.title // ""'
}

is_focused() {
    echo "$1" | jq -e '.is_focused == true' >/dev/null 2>&1
}

case "$ACTION" in
    notify)
        if has_niri; then
            window=$(find_window) || window=""
            if [ -n "$window" ]; then
                wid=$(get_window_id "$window")
                if ! is_focused "$window"; then
                    niri msg action set-window-urgent --id "$wid" 2>/dev/null || true
                    mkdir -p "$STATE_DIR"
                    echo "$wid $(date +%s)" > "$STATE_DIR/last-notified"
                    notify-send -a "Claude Code" -u normal \
                        "Claude Code needs input" \
                        "${PROJECT_NAME:-Claude Code}" 2>/dev/null || true
                fi
            else
                notify-send -a "Claude Code" -u normal \
                    "Claude Code needs input" 2>/dev/null || true
            fi
        else
            notify-send -a "Claude Code" -u normal \
                "Claude Code needs input" 2>/dev/null || true
        fi
        ;;
    stop)
        if has_niri; then
            window=$(find_window) || window=""
            if [ -n "$window" ]; then
                wid=$(get_window_id "$window")
                niri msg action unset-window-urgent --id "$wid" 2>/dev/null || true
            fi
        fi
        ;;
esac

exit 0
