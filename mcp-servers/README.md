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
