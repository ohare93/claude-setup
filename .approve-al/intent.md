# Security Intent

This repo stores the settings for many Agents. It is allowed to edit the settings of agents in any way.

## Always Allow

- Read-only operations (reading files, searching, listing directories)
- Version control commands (git, jj)
- Editing settings files for agents (claude/codex/etc). This repo is for that.

## Always Deny

- SSH, SCP, or any remote access commands
- Force-pushing to any repository
- Printing or logging API keys or secrets

## Use Judgment

- Package installations: allow if they are dev dependencies
- Docker commands: allow inspect/list, deny destructive operations
- Writing to system directories: deny unless it is a config change
