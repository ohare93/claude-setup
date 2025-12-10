---
description: Add or remove MCP servers to the current project's .mcp.json
---

# Setup MCP Server

**Usage**: `/setup-mcp add <server-name>` or `/setup-mcp remove <server-name>`

**Arguments**: `{{arg}}`

Parse the arguments to extract:
1. **Action**: First word (`add` or `remove`)
2. **Server name**: Second word (e.g., `unraid-ssh`, `filesystem`, `gitea`)

## Template Location

MCP server templates are in: `/home/jmo/Development/claude-setup/mcp-servers/`

## Execution

### For `add` action:

1. **Verify template exists**:
   ```bash
   ls /home/jmo/Development/claude-setup/mcp-servers/<server-name>.json
   ```
   If not found, list available templates and report error.

2. **Read the template**:
   ```bash
   cat /home/jmo/Development/claude-setup/mcp-servers/<server-name>.json
   ```

3. **Check for existing .mcp.json** in current working directory:
   - If exists: Read it, parse JSON
   - If not exists: Create empty structure `{ "mcpServers": {} }`

4. **Merge server from template**:
   - Template format: `{ "server-name": { config } }`
   - Extract: `mcpServers[serverName] = template[serverName]`
   - The server name from template key must match `<server-name>` argument

5. **Write the updated .mcp.json** to current working directory

6. **Report success**: Show what was added and remind user to restart Claude Code

### For `remove` action:

1. **Check .mcp.json exists** in current working directory
   If not found, report error: "No .mcp.json found in current project"

2. **Read and parse .mcp.json**

3. **Check server exists** in `mcpServers` object
   If not found, report error: "Server '<server-name>' not found in .mcp.json"

4. **Remove the server** from `mcpServers` object

5. **Write updated .mcp.json** (keep file even if mcpServers is empty)

6. **Report success**: Show what was removed and remind user to restart Claude Code

## Available Templates

List templates by checking files in `/home/jmo/Development/claude-setup/mcp-servers/*.json`

## Output Format

### Success (add):
```
Added <server-name> to .mcp.json

Current MCP servers:
- <server-1>
- <server-2>
- <server-name> (added)

Restart Claude Code to enable the new MCP server.
```

### Success (remove):
```
Removed <server-name> from .mcp.json

Remaining MCP servers:
- <server-1>
- <server-2>

Restart Claude Code to apply changes.
```

### Error (template not found):
```
Template '<server-name>' not found.

Available templates:
- filesystem
- gitea
- playwright
- serena
- sqlite
- unraid-ssh
```
