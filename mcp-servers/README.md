# MCP Servers Catalog

This directory documents MCP (Model Context Protocol) servers that extend Claude Code's capabilities with custom tools.

## What are MCP Servers?

MCP servers provide Claude Code with additional tools and capabilities beyond the built-in ones. They run as separate services (typically via Docker) and communicate with Claude Code through HTTP or SSE protocols.

## Available MCP Servers

### 1. Unraid SSH Server (`mcp-ssh-unraid`)

**Purpose**: Provides read-only access to Unraid server for debugging and monitoring

**Location**: `~/Development/DockerUnraid/mcp-ssh-unraid/`

**Connection**: HTTP MCP at `https://mcp.munchohare.com/mcp`

**Tools Provided** (86 total):
- **Docker Management**: List containers, view logs, inspect configurations, check stats
- **System Monitoring**: CPU/memory usage, disk space, temperatures, processes
- **Network Debugging**: Connection monitoring, port checking, DNS testing
- **Log Analysis**: Search logs, aggregate errors, create timelines
- **Health Checks**: Comprehensive system health, detect common issues
- **Unraid Specific**: Array status, parity checks, disk SMART data, share usage

**Key Features**:
- Read-only operations only (safe for debugging)
- Output filtering (grep, head, tail, sort, uniq, wc)
- Comprehensive filters to reduce context usage
- Authentication via SSH to Unraid server (port 2223)

**Use Cases**:
- Debug Docker containers without direct SSH access
- Monitor system health and resources
- Analyze logs across all containers
- Check array status and disk health
- Troubleshoot network issues

**Configuration**:
```json
{
  "type": "http",
  "url": "https://mcp.munchohare.com/mcp"
}
```

### 2. File Manager Server (`mcp-filemanager`)

**Purpose**: Manage files with privacy-preserving anonymization

**Location**: `~/Development/DockerUnraid/mcp-filemanager/`

**Connection**: SSE endpoint (exact URL in compose.yaml)

**Tools Provided**:
- File listing with privacy-filter integration
- File operations (move, copy, delete)
- Directory management
- File search and tree views
- File metadata retrieval

**Key Features**:
- Privacy-filter integration for filename anonymization
- Consistent anonymization (same file = same anonymized name)
- Path security (all operations constrained to BASE_DIR)
- Error messages never leak real filenames

**Use Cases**:
- Organize files while maintaining privacy
- Bulk file operations with filtering
- File discovery without revealing actual names

**Configuration**: See `~/Development/DockerUnraid/mcp-filemanager/README.md`

### 3. Serena Coding Agent (`serena`)

**Purpose**: Semantic code analysis and intelligent editing using language servers

**Repository**: https://github.com/oraios/serena

**Connection**: stdio transport via Nix

**Tools Provided**:
- Semantic code retrieval and navigation
- Language server-powered code analysis
- IDE-like code editing capabilities
- Multi-language support (Rust, Python, TypeScript, Go, etc.)
- Context-aware code suggestions

**Key Features**:
- Zero-config language server integration
- Works directly with LSP (Language Server Protocol)
- Semantic understanding beyond simple text search
- Type-aware refactoring and navigation
- Free and open-source

**Use Cases**:
- Navigate large codebases semantically
- Find symbol definitions and references
- Type-aware code completion
- Intelligent refactoring assistance
- Multi-language project analysis

**Configuration File**: `mcp-servers/serena.json`

**Installation**:
```bash
# Option 1: Add via Claude Code CLI
claude mcp add --transport stdio serena -- nix run github:oraios/serena -- start-mcp-server --transport stdio

# Option 2: Manually add to ~/.claude/settings.json
# Copy the contents of mcp-servers/serena.json into the "mcpServers" section
```

**Manual Setup**:
1. Open `~/.claude/settings.json`
2. Add the contents of `mcp-servers/serena.json` to the `mcpServers` section
3. Restart Claude Code

**Requirements**:
- Nix with flakes enabled (`nix-command` and `flakes` features)
- Language servers for desired languages (Serena handles installation)

### 4. Filesystem Server (`filesystem`)

**Purpose**: Secure local file operations with configurable directory access

**Repository**: https://github.com/modelcontextprotocol/servers

**Connection**: stdio transport via npx

**Tools Provided**:
- Read files from allowed directories
- Write files to allowed directories
- Create and delete directories
- Move and copy files
- List directory contents
- Search for files

**Key Features**:
- Configurable directory access control
- Restricted to specific paths for security
- Full read/write capabilities within allowed directories
- Direct filesystem access without intermediate tools

**Use Cases**:
- Read and modify project files
- Organize development workspace
- Quick file operations during coding sessions
- Access temporary files for testing

**Configured Directories**:
- `/home/jmo/Development` - Main development directory (read/write) **⚠️ CUSTOMIZE THIS PATH**
- `/tmp` - Temporary files location (read/write)

**⚠️ Important Setup Note**:
The filesystem server is configured with `/home/jmo/Development` as the default path. **You must update this path** to match your actual development directory:

1. Edit `.mcp.json` - Update the `filesystem.args` array
2. Edit `mcp-servers/filesystem.json` - Update the args array
3. Replace `/home/jmo/Development` with your actual development path (e.g., `/home/youruser/Development`)

**Configuration Files**:
- `.mcp.json` (active runtime configuration)
- `mcp-servers/filesystem.json` (plugin marketplace configuration)

**Requirements**:
- Node.js and npx (installed globally via NixOS configuration)

### 5. Gitea Server (`gitea`)

**Purpose**: Integration with self-hosted Gitea instance at git.munchohare.com

**Repository**: https://gitea.com/gitea/gitea-mcp

**Connection**: stdio transport via Docker

**Tools Provided**:
- Create repositories
- Upload files with directory structure
- Manage issues and pull requests
- Clone and sync projects
- Update files with conflict resolution
- Search repositories and code

**Key Features**:
- Native integration with Gitea/Forgejo
- Multi-instance support possible
- Natural language repository operations
- Preserves directory structure during uploads
- Smart update tools with conflict resolution

**Use Cases**:
- Create and manage repositories on your Gitea instance
- Push code changes to Gitea
- Manage issues and pull requests
- Sync local projects with Gitea
- Search and navigate repositories

**Setup Instructions**:

1. **Generate Gitea Access Token**:
   - Go to https://git.munchohare.com/user/settings/applications
   - Click "Generate New Token"
   - Give it a descriptive name (e.g., "Claude Code MCP")
   - Select appropriate permissions (repo access recommended)
   - Copy the generated token

2. **Set Environment Variable**:
   ```bash
   export GITEA_ACCESS_TOKEN="your-token-here"
   ```

   Add to your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc.):
   ```bash
   export GITEA_ACCESS_TOKEN="your-token-here"
   ```

3. **Test Connection**:
   After restarting Claude Code, the Gitea MCP server should connect automatically.

**Configuration File**: `mcp-servers/gitea.json`

**Requirements**:
- Docker (for running the official Gitea MCP server container)
- Gitea personal access token with appropriate permissions
- GITEA_ACCESS_TOKEN environment variable set

**Security Notes**:
- Never commit your access token to version control
- Store token in environment variables only
- Use token with minimum required permissions
- Rotate tokens periodically

### 6. SQLite Server (`sqlite`)

**Purpose**: Database interaction and business intelligence for SQLite databases

**Repository**: https://github.com/modelcontextprotocol/servers

**Connection**: stdio transport via npx

**Tools Provided**:
- Execute SQL queries
- Create and manage tables
- Insert, update, and delete data
- Schema inspection and analysis
- Database backups and exports
- Query optimization suggestions

**Key Features**:
- Direct SQL query execution
- Schema exploration
- Data analysis capabilities
- Transaction support
- Safe query execution with validation
- Support for multiple database files

**Use Cases**:
- Analyze data in SQLite databases
- Run queries for debugging
- Create and modify database schemas
- Generate reports from data
- Test SQL queries during development
- Database migration assistance

**Default Database**: `/tmp/test.db` (can be changed in configuration)

**Configuration File**: `mcp-servers/sqlite.json`

**Configuration Options**:
To use a different database file, modify `mcp-servers/sqlite.json`:
```json
{
  "sqlite": {
    "command": "npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-sqlite",
      "--db-path",
      "/path/to/your/database.db"
    ]
  }
}
```

**Requirements**:
- Node.js and npx (installed globally via NixOS configuration)

### 7. Code-Mode (`code-mode`)

**Purpose**: Execute complex workflows through TypeScript code rather than sequential tool calls

**Repository**: https://github.com/universal-tool-calling-protocol/code-mode

**Connection**: stdio transport via npx

**Tools Provided**:
- **call_tool_chain**: Execute TypeScript code that can call multiple tools simultaneously
- **Progressive tool discovery**: Dynamically load only relevant tools
- **Multi-protocol support**: Access MCP, HTTP, File, and CLI tools from single code block

**Key Features**:
- 60% faster execution than traditional tool calling
- 68% fewer tokens consumed
- 88% fewer API round trips
- Secure VM sandboxing for safe code execution
- Auto-generated TypeScript interfaces for all available tools
- Configurable execution timeouts
- Complete console output capture

**Performance Benefits**:
Traditional approach (multiple sequential tool calls):
```
Call tool A → Wait → Call tool B → Wait → Call tool C → Wait
(High latency, many API calls, lots of tokens)
```

Code-mode approach (single code execution):
```typescript
// Single execution calling multiple tools
const resultA = await toolA();
const resultB = await toolB(resultA);
const resultC = await toolC(resultB);
```
(Low latency, one API call, minimal tokens)

**Use Cases**:
- Complex multi-tool workflows that need to run efficiently
- Data processing pipelines requiring multiple tool interactions
- Reducing token costs on repetitive tool-heavy operations
- Building adaptive workflows with runtime tool discovery
- Enterprise applications needing cost optimization

**Configuration File**: `mcp-servers/code-mode.json`

**Installation**:
```bash
# Automatically installed via .mcp.json configuration
# Uses npx to run @utcp/code-mode-mcp
```

**Advanced Configuration**:
To configure specific tool sources, set the `UTCP_CONFIG_FILE` environment variable:
```json
{
  "code-mode": {
    "command": "npx",
    "args": ["-y", "@utcp/code-mode-mcp"],
    "env": {
      "UTCP_CONFIG_FILE": "/path/to/.utcp_config.json"
    }
  }
}
```

**Cost Savings Example**:
According to independent benchmarks, code-mode can save approximately $9,536/year at enterprise scale by reducing:
- API round trips (88% reduction)
- Token consumption (68% reduction)
- Execution time (60% improvement)

**Requirements**:
- Node.js and npx (installed globally via NixOS configuration)

### 8. Playwright MCP Server (`playwright`)

**Purpose**: Browser automation for web testing, scraping, and interaction

**Repository**: https://github.com/microsoft/playwright-mcp

**Connection**: stdio transport via npx

**Tools Provided**:
- **Navigation & Interaction**: Click, drag, fill forms, submit data
- **Page Inspection**: Accessibility snapshots, console messages
- **Content Manipulation**: Execute JavaScript, access element attributes
- **Advanced Features**: PDF generation, vision-based interactions, tab management
- **Session Management**: Browser context handling, storage state preservation

**Key Features**:
- Structured accessibility snapshots instead of screenshots
- Full Playwright automation capabilities
- Cross-browser support (Chromium, Firefox, WebKit)
- Network interception and modification
- Mobile device emulation
- Proxy support and network filtering

**Use Cases**:
- Automated web testing and QA
- Web scraping and data extraction
- Form automation and submission
- Browser-based workflow automation
- Screenshot and PDF generation
- Testing responsive designs

**Configuration File**: `mcp-servers/playwright.json`

**Installation**:
```bash
# Automatically installed via .mcp.json configuration
# Uses npx to run @playwright/mcp@latest
```

**Configuration Options**:
The server supports various command-line options:
```json
{
  "playwright": {
    "command": "npx",
    "args": [
      "-y",
      "@playwright/mcp@latest",
      "--browser", "chromium",
      "--viewport-width", "1920",
      "--viewport-height", "1080"
    ]
  }
}
```

Available options:
- `--browser`: Browser type (chromium, firefox, webkit)
- `--headless`: Run in headless mode (default: true)
- `--viewport-width`, `--viewport-height`: Set viewport size
- `--proxy`: Configure HTTP proxy
- `--disable-timeout`: Disable operation timeouts

**Requirements**:
- Node.js 18 or newer
- npx (installed globally via NixOS configuration)
- Playwright browsers (auto-installed on first use)

## Claude Code Plugins

The following are Claude Code plugins (not MCP servers) that extend Claude Code's capabilities through the plugin system:

### 9. Superpowers (`superpowers`)

**Purpose**: Comprehensive skills library for systematic software development

**Repository**: https://github.com/obra/superpowers

**Type**: Claude Code Plugin (Skills Library)

**Tools Provided**:
- **Testing**: Test-driven development, async testing patterns, anti-pattern avoidance
- **Debugging**: Systematic debugging methodology, root cause analysis, verification
- **Collaboration**: Brainstorming, planning, code review, parallel agent coordination
- **Development**: Git worktree usage, branch management, subagent workflows
- **Meta**: Skill creation, testing, and contribution processes

**Key Features**:
- Automatic skill activation based on task context
- SessionStart hook for seamless integration
- Three main slash commands for workflow management
- Structured approaches to common development tasks
- Extensible skill system

**Available Commands**:
- `/superpowers:brainstorm` - Collaborative brainstorming
- `/superpowers:write-plan` - Create execution plans
- `/superpowers:execute-plan` - Execute planned tasks

**Use Cases**:
- Systematic test-driven development
- Structured debugging workflows
- Team collaboration and planning
- Git workflow management
- Creating and testing new skills

**Installation**:
```bash
# In Claude Code, run:
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace

# Verify installation:
/help
```

**Requirements**:
- Claude Code with plugin support
- No additional dependencies

### 10. Claude Notifications Go (`claude-notifications-go`)

**Purpose**: Intelligent desktop notifications for Claude Code task status

**Repository**: https://github.com/777genius/claude-notifications-go

**Type**: Claude Code Plugin (Notification System)

**Notification Types**:
- **Task Complete** (✅): Main tasks finish
- **Review Complete** (🔍): Code reviews conclude
- **Question** (❓): Claude needs clarification
- **Plan Ready** (📋): Execution plans await approval
- **Session Limit Reached** (⏱️): Session constraints warning
- **API Error: 401** (🔴): Authentication expiration

**Key Features**:
- Desktop notifications with custom icons and sounds
- Webhook integrations (Slack, Discord, Telegram, custom)
- Configurable sound alerts
- Automatic task detection
- Cross-platform support (Windows, macOS, Linux)

**Available Commands**:
- `/claude-notifications-go:notifications-init` - Initialize sound configuration
- `/claude-notifications-go:notifications-settings` - Configure notification settings

**Use Cases**:
- Monitor long-running Claude Code sessions
- Get alerts when tasks need attention
- Integrate with team chat systems
- Track session limits and errors
- Stay informed without constant monitoring

**Installation**:
```bash
# In Claude Code, run:
/plugin marketplace add 777genius/claude-notifications-go
/plugin install claude-notifications-go@claude-notifications-go

# Configure:
/claude-notifications-go:notifications-init
/claude-notifications-go:notifications-settings
```

**Requirements**:
- Claude Code v2.0.15 or higher
- Windows: Git Bash or WSL
- macOS/Linux: No additional software needed

### 11. Claude-Mem (`claude-mem`)

**Purpose**: Persistent memory compression across coding sessions

**Repository**: https://github.com/thedotmack/claude-mem

**Type**: Claude Code Plugin with MCP Tools

**MCP Tools Provided** (7 search tools):
- `search_observations` - Full-text search across captured observations
- `search_sessions` - Query session summaries
- `search_user_prompts` - Search raw user requests
- `find_by_concept` - Locate items by concept tags
- `find_by_file` - Search by file references
- `find_by_type` - Filter by observation type (decision, bugfix, feature)
- `get_recent_context` - Retrieve recent session context

**Key Features**:
- Automatic tool usage observation capture
- AI-powered session summarization
- Historical context availability in future sessions
- Layered memory retrieval with token cost visibility
- Citations linking back to specific past observations
- SQLite database with FTS5 full-text search
- HTTP API on port 37777 (managed by PM2)

**Use Cases**:
- Maintain context across multiple coding sessions
- Search previous decisions and implementations
- Learn from past debugging sessions
- Track feature development history
- Quick access to historical context
- Cross-session knowledge retention

**Available Commands**:
- See the 7 MCP search tools listed above (available as Claude Code tools)

**Installation**:
```bash
# In Claude Code, run:
/plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem

# The plugin will automatically:
# - Start HTTP API on port 37777
# - Begin capturing observations
# - Make MCP tools available
```

**Configuration**:
Environment variables (optional):
- `CLAUDE_MEM_MODEL` - Default: claude-sonnet-4-5
- `CLAUDE_MEM_WORKER_PORT` - Default: 37777

Configure via: `./claude-mem-settings.sh`

**Architecture**:
- **Database**: SQLite with FTS5 full-text search
- **API**: HTTP API on port 37777
- **Process Management**: PM2 for background service
- **Hooks**: 5 lifecycle hooks (SessionStart, UserPromptSubmit, PostToolUse, Stop, SessionEnd)

**Requirements**:
- Node.js 18.0.0 or higher
- Claude Code with plugin support
- PM2 (bundled)
- SQLite 3 (bundled)

## Understanding the Difference: MCP Servers vs Plugins

### MCP Servers
MCP servers are standalone services that communicate via the Model Context Protocol:
- Run as separate processes (stdio, HTTP, or SSE transport)
- Configured in `.mcp.json` or `~/.claude/settings.json`
- Examples: serena, filesystem, gitea, sqlite, playwright
- Provide tools that appear in Claude Code's tool palette

### Claude Code Plugins
Plugins extend Claude Code through its plugin system:
- Install via `/plugin marketplace add` and `/plugin install`
- Can hook into Claude Code lifecycle events
- May include slash commands, skills, or notification handlers
- Examples: superpowers, claude-notifications-go, claude-mem

### Hybrid Plugins
Some plugins (like claude-mem) also expose MCP tools:
- Installed as plugins
- Run background services that provide MCP tools
- Best of both worlds: plugin integration + MCP tool availability

## How to Add a New MCP Server

1. **Develop the server** following MCP protocol specification
2. **Create documentation** similar to entries above
3. **Add to this catalog** with connection details
4. **Test with Claude Code** to verify functionality
5. **Document in project CLAUDE.md** for project-specific usage

## MCP Server Best Practices

### Development
- Follow MCP protocol specification strictly
- Provide clear tool descriptions and parameter schemas
- Implement proper error handling
- Use TypeScript/JSON schemas for type safety

### Security
- Authenticate requests when exposing publicly
- Use read-only operations when possible
- Validate all inputs and paths
- Never leak sensitive information in error messages

### Performance
- Implement output filtering (grep, head, tail)
- Cache results when appropriate
- Set reasonable timeouts
- Limit output size to manage context

### Documentation
- Document all available tools
- Provide usage examples
- Explain authentication requirements
- List common use cases

## Connecting MCP Servers to Claude Code

### HTTP/JSON-RPC Servers
Add to Claude Code MCP configuration:
```json
{
  "type": "http",
  "url": "https://your-server.com/mcp"
}
```

### SSE (Server-Sent Events) Servers
Add to Claude Code MCP configuration:
```json
{
  "type": "sse",
  "url": "https://your-server.com/sse"
}
```

### Local Servers
For development/testing:
```json
{
  "type": "http",
  "url": "http://localhost:3000/mcp"
}
```

## Debugging MCP Servers

### Check Health Endpoint
```bash
curl http://localhost:3000/health
```

### List Available Tools
```bash
curl -X POST http://localhost:3000/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'
```

### Test Tool Call
```bash
curl -X POST http://localhost:3000/mcp \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc":"2.0",
    "id":2,
    "method":"tools/call",
    "params":{
      "name":"tool_name",
      "arguments":{"param":"value"}
    }
  }'
```

### Check Logs
```bash
docker compose logs -f mcp-server
```

## Resources

- **MCP Specification**: https://github.com/anthropics/model-context-protocol
- **Example Servers**: https://github.com/modelcontextprotocol/servers
- **Claude Code MCP Docs**: https://docs.claude.com/en/docs/claude-code/mcp

## Related Configuration

MCP server URLs are configured in:
- **Global**: `~/.claude/settings.json`
- **Project**: `.claude/settings.local.json` in project root

Can also be configured via environment variables and CLI arguments.
