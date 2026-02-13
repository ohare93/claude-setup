#!/usr/bin/env bash
# Focus the most recently notified Claude Code window in Niri
# Intended for use as a Niri keybind (e.g. Mod+C)

STATE_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/claude-niri"
STATE_FILE="$STATE_DIR/last-notified"

focus_and_clear() {
    local wid="$1"
    niri msg action focus-window --id "$wid" 2>/dev/null || return 1
    niri msg action unset-window-urgent --id "$wid" 2>/dev/null || true
}

window_exists() {
    local wid="$1"
    niri msg --json windows 2>/dev/null | \
        jq -e --argjson id "$wid" '.[] | select(.id == $id)' >/dev/null 2>&1
}

# Try the most recently notified window first
if [ -f "$STATE_FILE" ]; then
    wid=$(awk '{print $1}' "$STATE_FILE")
    if [ -n "$wid" ] && window_exists "$wid"; then
        focus_and_clear "$wid" || true
        rm -f "$STATE_FILE"
        exit 0
    fi
    rm -f "$STATE_FILE"
fi

# Fallback: find any urgent kitty window
urgent_wid=$(niri msg --json windows 2>/dev/null | \
    jq -r 'first(.[] | select(.app_id == "kitty" and .is_urgent == true) | .id) // empty' 2>/dev/null || echo "")

if [ -n "$urgent_wid" ]; then
    focus_and_clear "$urgent_wid" || true
    exit 0
fi

# Last resort: find any kitty window with "Claude Code" in the title
claude_wid=$(niri msg --json windows 2>/dev/null | \
    jq -r 'first(.[] | select(.app_id == "kitty" and (.title | test("Claude Code"))) | .id) // empty' 2>/dev/null || echo "")

if [ -n "$claude_wid" ]; then
    focus_and_clear "$claude_wid" || true
    exit 0
fi

exit 0
