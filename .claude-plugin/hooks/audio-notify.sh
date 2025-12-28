#!/usr/bin/env bash
# Audio notification hook for Claude Code
# Plays a non-blocking sound notification using PipeWire

set -euo pipefail

# Sound type from first argument: "stop" or "notify"
SOUND_TYPE="${1:-notify}"

case "$SOUND_TYPE" in
    stop)
        # Two-tone completion sound (400Hz then 500Hz)
        SOUND_FILE="/tmp/claude-stop.wav"
        sox -n "$SOUND_FILE" synth 0.2 sine 400 synth 0.1 sine 500 2>/dev/null
        ;;
    notify|*)
        # Single tone notification (400Hz)
        SOUND_FILE="/tmp/claude-notify.wav"
        sox -n "$SOUND_FILE" synth 0.2 sine 400 2>/dev/null
        ;;
esac

# Play with timeout to prevent blocking, run in background
timeout 2 pw-play "$SOUND_FILE" 2>/dev/null &

exit 0
