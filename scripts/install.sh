#!/usr/bin/env bash
set -euo pipefail

# Claude Setup Installation Script
# Deploys custom agents, commands, and configurations to ~/.claude/

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
CLAUDE_DIR="$HOME/.claude"

echo "Claude Setup Installer"
echo "======================"
echo ""

# Create directories if they don't exist
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/commands"

echo "Installing custom agents..."
for agent in "$REPO_ROOT/agents"/*.md; do
    if [ -f "$agent" ]; then
        basename="$(basename "$agent")"
        cp "$agent" "$CLAUDE_DIR/agents/$basename"
        echo "  ✓ Installed $(basename "$agent" .md)"
    fi
done

echo ""
echo "Installing slash commands..."
for command in "$REPO_ROOT/commands"/*.md; do
    if [ -f "$command" ]; then
        basename="$(basename "$command")"
        cp "$command" "$CLAUDE_DIR/commands/$basename"
        echo "  ✓ Installed /$(basename "$command" .md)"
    fi
done

echo ""
echo "Installation complete!"
echo ""
echo "Installed components:"
echo "  - Agents: ~/.claude/agents/"
echo "  - Commands: ~/.claude/commands/"
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code to load new agents and commands"
echo "  2. Review docs/global-instructions.md for usage guidelines"
echo "  3. Use templates/ to create project-specific CLAUDE.md files"
echo ""
echo "To update from this repo, run this script again."
