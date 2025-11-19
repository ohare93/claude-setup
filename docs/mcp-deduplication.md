# MCP Context Deduplication - Approach 2 Implementation

**Date:** 2025-11-19
**Issue:** MCP tools consuming ~193,652 tokens (exceeding 25,000 threshold)

## Problem Summary

MCP servers were being loaded **twice**:
1. From project-level `.mcp.json` → loaded without prefix
2. From plugin `marketplace.json` mcpServers → loaded with `plugin_jmo-development-tools_` prefix

Example duplication:
- `serena`: 29 tools (~22,060 tokens)
- `plugin_jmo-development-tools_serena`: 29 tools (~22,321 tokens)
- **Total for one server:** ~44,381 tokens

This pattern repeated for: serena, playwright, filesystem, gitea, sqlite, code-mode

## Solution Implemented: Approach 2 (Plugin-Only MCP Servers)

### Changes Made

1. **Deleted** `/home/jmo/Development/claude-setup/.mcp.json`
   - This file was duplicating all MCP server definitions
   - All MCP servers are now loaded exclusively through the plugin

2. **Updated** `/home/jmo/Development/claude-setup/.claude/settings.local.json`
   - Removed `enableAllProjectMcpServers: true`
   - Removed `enabledMcpjsonServers: ["serena"]`
   - These settings are no longer needed without .mcp.json

### Expected Results

After restarting Claude:
- **Context reduction:** ~193k → ~97k tokens (50% reduction)
- All MCP servers will load with `plugin_jmo-development-tools_` prefix only
- No duplicate MCP server loading
- All functionality preserved - same servers available, just loaded once

### MCP Servers Available (via Plugin)

The following servers are defined in `.claude-plugin/marketplace.json` mcpServers:
- `filesystem` - File system operations
- `gitea` - Gitea repository management
- `playwright` - Browser automation
- `serena` - Semantic code analysis
- `sqlite` - SQLite database operations

Configuration files in `mcp-servers/` directory:
- `mcp-servers/filesystem.json`
- `mcp-servers/gitea.json`
- `mcp-servers/playwright.json`
- `mcp-servers/serena.json`
- `mcp-servers/sqlite.json`

### Customization

To customize MCP server configurations per-project:
1. **Option A:** Edit the plugin's MCP server configs in `mcp-servers/*.json`
   - Affects all projects using this plugin
   - Good for global defaults

2. **Option B:** Use `.claude/settings.local.json` permissions to control tool access
   - Project-specific tool filtering
   - Doesn't change server configuration, just access control

3. **Option C:** Create project-specific `.mcp.json` if needed
   - Overrides plugin servers for that project only
   - May reintroduce duplication if not managed carefully

### Trade-offs Accepted

**Pros:**
- ✅ Eliminated context bloat (~96k token savings)
- ✅ Single source of truth for MCP configurations
- ✅ Simpler mental model - plugin manages all MCP servers
- ✅ Centralized updates

**Cons:**
- ❌ Per-project customization requires editing plugin files
- ❌ All projects share the same MCP server configurations
- ❌ Can't easily override args (e.g., filesystem paths) per project

### Verification

Run `/doctor` after restarting Claude to verify:
- MCP tools context should be ~97k tokens (down from ~193k)
- Each server should appear only once with `plugin_jmo-development-tools_` prefix
- No duplicate server entries

### Rollback Procedure

If issues arise, restore previous state:
1. Recreate `.mcp.json` with previous content (see git history)
2. Update `.claude/settings.local.json` to add back:
   ```json
   "enableAllProjectMcpServers": true,
   "enabledMcpjsonServers": ["serena"]
   ```
3. Restart Claude

## Alternative Approaches Considered

**Approach 1: Plugin as Template Provider**
- Plugin provides example configs in `mcp-servers-templates/`
- Users manually copy to project `.mcp.json`
- More flexible per-project, but requires manual setup

**Approach 3: Hybrid Auto-Detection**
- Plugin auto-detects `.mcp.json` existence
- Conditional loading to prevent duplication
- More complex, "magic" behavior
