#!/usr/bin/env bash
set -euo pipefail

# Claude Setup Sync Script
# Syncs changes from ~/.claude/ back to the repository

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
CLAUDE_DIR="$HOME/.claude"

echo "Claude Setup Sync Tool"
echo "======================"
echo ""
echo "This script syncs changes from ~/.claude/ back to the repository."
echo ""

# Check if there are any agents to sync
if [ -d "$CLAUDE_DIR/agents" ] && [ "$(ls -A "$CLAUDE_DIR/agents"/*.md 2>/dev/null)" ]; then
    echo "Syncing agents..."
    for agent in "$CLAUDE_DIR/agents"/*.md; do
        if [ -f "$agent" ]; then
            basename="$(basename "$agent")"
            cp "$agent" "$REPO_ROOT/agents/$basename"
            echo "  ✓ Synced $(basename "$agent" .md)"
        fi
    done
else
    echo "No agents to sync."
fi

# Check if there are any commands to sync
echo ""
if [ -d "$CLAUDE_DIR/commands" ] && [ "$(ls -A "$CLAUDE_DIR/commands"/*.md 2>/dev/null)" ]; then
    echo "Syncing commands..."
    for command in "$CLAUDE_DIR/commands"/*.md; do
        if [ -f "$command" ]; then
            basename="$(basename "$command")"
            cp "$command" "$REPO_ROOT/commands/$basename"
            echo "  ✓ Synced /$(basename "$command" .md)"
        fi
    done
else
    echo "No commands to sync."
fi

# Sync global CLAUDE.md if it exists
echo ""
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    echo "Syncing global instructions..."
    cp "$CLAUDE_DIR/CLAUDE.md" "$REPO_ROOT/docs/global-instructions.md"
    echo "  ✓ Synced global instructions"
else
    echo "No global CLAUDE.md to sync."
fi

echo ""
echo "Sync complete!"
echo ""
echo "Next steps:"
echo "  1. Review changes: jj diff"
echo "  2. Commit if satisfied: jj describe -m 'sync: update from ~/.claude/'"
echo "  3. Push to remote: jj git push"
