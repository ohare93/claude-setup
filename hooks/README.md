# Plugin Hooks

Executable hooks wired into Claude Code via `hooks.json`. These are shell scripts that inspect, modify, or block tool calls — distinct from the markdown prompt-injection "hooks" in [`../hooks-docs/`](../hooks-docs/).

## Wiring

Hooks load from `<plugin-root>/hooks/hooks.json` by convention (see [Hookify](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/hookify) for the canonical template). The `"hooks"` field in `marketplace.json` is ignored — do not use it.

All hook commands reference `${CLAUDE_PLUGIN_ROOT}/hooks/<script>.sh`, which Claude Code resolves to the installed plugin path.

## Currently wired

### `prefer-modern-tools.sh`

- **Event:** PreToolUse
- **Matcher:** Bash
- **Behavior:** Blocks Bash commands containing `grep` or `find` (exit code 2) with a message to use `rg` or `fd` instead. Detects usage via word-boundary regex so pipes and subshells are caught.

### `niri-notify.sh`

- **Events:** Stop + Notification → `notify` mode · UserPromptSubmit → `stop` mode
- **Behavior:**
  - `notify` — Sets Niri window urgency on the kitty window running Claude (matched via `KITTY_PID` against Niri's window list) and emits a `notify-send` desktop notification. Skipped if the window is already focused.
  - `stop` — Clears the urgency flag when you submit a new prompt.
- **Requirements:** `niri`, `jq`, `notify-send`, a graphical session with `NIRI_SOCKET` set, and `KITTY_PID` in the environment.
- **State:** Last-notified window ID/timestamp written to `$XDG_RUNTIME_DIR/claude-niri/last-notified`.

## Available but not wired

### `debug-hook.sh`

Diagnostic hook that logs event name, PID/PPID, `KITTY_PID`, `CLAUDE_PLUGIN_ROOT`, `PWD`, and stdin JSON to `$XDG_RUNTIME_DIR/claude-debug/debug.log`. Useful when hooks aren't firing or to inspect what Claude passes. Wire it in `hooks.json` by replacing a command like `niri-notify.sh notify` with `debug-hook.sh <EventName>`.

### `audio-notify.sh`

Plays a generated sine tone via PipeWire (`sox` + `pw-play`) on `stop` (two-tone) or `notify` (single tone). Non-blocking, runs in background.

### `stop.sh`

Formats token/cache/cost for a status line. Uses hardcoded Sonnet 4.5 pricing — update rates before reuse.

## External scripts

### `niri-focus-claude.sh`

Not a hook — a standalone script for a Niri keybind. Finds the urgent kitty window (or falls back to the most recently notified window from `niri-notify.sh` state) and focuses it. Bind to a key in your Niri config:

```kdl
binds {
    Mod+C { spawn "<plugin-root>/hooks/niri-focus-claude.sh"; }
}
```

## Writing new hooks

PreToolUse hooks receive JSON on stdin:

```json
{"tool_name": "Bash", "tool_input": {"command": "..."}}
```

- Exit `0` → allow
- Exit `2` → block (stderr shown to Claude)

Stop / Notification / UserPromptSubmit hooks receive richer context including `session_id`, `cwd`, `permission_mode`, and `last_assistant_message` (Stop only). Use `timeout 1 cat` to read stdin safely — the hook runner does not always close it.

Reference `${CLAUDE_PLUGIN_ROOT}/hooks/<script>.sh` in `hooks.json`, not absolute paths.
