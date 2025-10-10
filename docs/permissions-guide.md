# Claude Code Permissions Guide

Claude Code has a flexible permissions system that allows you to pre-approve specific tool operations. This guide explains how to configure permissions effectively.

## Permission Levels

Permissions can be configured at two levels:

1. **Global** (`~/.claude/settings.json`) - Applies to all projects
2. **Project-specific** (`.claude/settings.local.json`) - Applies only to that project

Project permissions merge with global permissions (allowing additional operations).

## Configuration File Format

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "ToolName(param:pattern)",
      "ToolName(param:pattern)"
    ],
    "deny": [
      "ToolName(param:pattern)"
    ]
  }
}
```

## Permission Patterns

### Basic Syntax

```json
"ToolName"                    // Allow all uses of this tool
"ToolName(param:value)"       // Allow when param equals value
"ToolName(param:prefix*)"     // Allow when param starts with prefix
"ToolName(param:**)"          // Allow any value for param
```

### Common Patterns

#### Web Fetching
```json
"WebFetch(domain:github.com)"              // Allow GitHub
"WebFetch(domain:*.github.com)"            // Allow GitHub subdomains
"WebFetch(domain:raw.githubusercontent.com)" // Allow raw content
"WebSearch"                                 // Allow web searches
```

#### Bash Commands
```json
"Bash(command:ls*)"          // Allow ls with any arguments
"Bash(command:mkdir*)"       // Allow mkdir
"Bash(command:cat*)"         // Allow cat
"Bash(command:grep*)"        // Allow grep
"Bash(command:jj log*)"      // Allow jj log commands
"Bash(command:docker compose*)" // Allow docker compose
```

#### File Operations
```json
"Read(file_path://home/user/project/**)"     // Allow reading project files
"Write(file_path://home/user/project/**)"    // Allow writing to project
"Edit(file_path://home/user/project/**)"     // Allow editing project files
```

#### MCP Tools
```json
"mcp__server-name__tool_name"               // Allow specific MCP tool
"mcp__unraid-ssh__docker_logs"              // Allow viewing Docker logs
"mcp__unraid-ssh__system_get_system_info"   // Allow system info
```

## Recommended Permission Sets

### Minimal Safe Permissions

Good starting point for most projects:

```json
{
  "permissions": {
    "allow": [
      "WebFetch(domain:github.com)",
      "WebSearch",
      "Bash(command:ls*)",
      "Bash(command:cat*)",
      "Bash(command:grep*)",
      "Read(file_path://home/user/Development/**)"
    ],
    "deny": []
  }
}
```

### Development Project Permissions

For active development projects:

```json
{
  "permissions": {
    "allow": [
      "WebFetch(domain:github.com)",
      "WebFetch(domain:raw.githubusercontent.com)",
      "WebSearch",
      "Bash(command:mkdir*)",
      "Bash(command:ls*)",
      "Bash(command:cat*)",
      "Bash(command:grep*)",
      "Bash(command:jj*)",
      "Read(file_path://home/user/Development/**)",
      "Write(file_path://home/user/Development/my-project/**)",
      "Edit(file_path://home/user/Development/my-project/**)"
    ],
    "deny": []
  }
}
```

### Docker/Infrastructure Permissions

For working with containers and infrastructure:

```json
{
  "permissions": {
    "allow": [
      "WebFetch(domain:github.com)",
      "WebFetch(domain:hub.docker.com)",
      "WebSearch",
      "Bash(command:docker*)",
      "Bash(command:curl*)",
      "Bash(command:ls*)",
      "Bash(command:cat*)",
      "mcp__unraid-ssh__docker_logs",
      "mcp__unraid-ssh__docker_list_containers",
      "mcp__unraid-ssh__docker_inspect",
      "mcp__unraid-ssh__system_get_system_info",
      "Read(file_path://home/user/Development/**)"
    ],
    "deny": []
  }
}
```

### Debugging Permissions

For troubleshooting and debugging:

```json
{
  "permissions": {
    "allow": [
      "WebSearch",
      "Bash(command:*)",  // Allow all bash commands (use with caution!)
      "Read(file_path:**)",
      "mcp__unraid-ssh__log_grep_all_logs",
      "mcp__unraid-ssh__log_timeline",
      "mcp__unraid-ssh__log_error_aggregator",
      "mcp__unraid-ssh__health_check_comprehensive"
    ],
    "deny": []
  }
}
```

## Security Considerations

### Safe Permissions

These are generally safe to allow globally:

- Read-only file operations in your projects
- Web fetching from known domains (GitHub, docs sites)
- Read-only bash commands (`ls`, `cat`, `grep`)
- Read-only MCP tools (viewing logs, system info)
- Web searches

### Use with Caution

These should be limited to specific projects:

- Write/Edit operations
- Directory creation/deletion
- Docker operations
- System modifications
- MCP tools that modify state

### Never Allow Globally

These should require explicit approval each time:

- File deletion
- System administration commands
- SSH operations to production servers
- Database modifications
- Deployment operations

## Permission Wildcards

### Path Wildcards

```json
"Read(file_path://home/user/**)"           // All files under user
"Read(file_path://home/user/project/**)"   // All files in project
"Read(file_path:**/config/**)"             // Config dirs anywhere
```

### Command Wildcards

```json
"Bash(command:jj*)"        // All jj commands
"Bash(command:docker compose*)"  // All docker compose commands
"Bash(command:npm run*)"   // All npm run commands
```

## Deny Rules

Deny rules take precedence over allow rules:

```json
{
  "permissions": {
    "allow": [
      "Bash(command:rm*)"  // Allow rm commands
    ],
    "deny": [
      "Bash(command:rm -rf /*)"  // But not THIS rm command
    ]
  }
}
```

## Testing Permissions

To test if a permission is working:

1. Try the operation in Claude Code
2. If blocked, check the error message
3. Add appropriate permission pattern
4. Retry the operation

## Debugging Permission Issues

### Permission Not Working

1. **Check syntax** - Ensure proper JSON format
2. **Check pattern** - Verify wildcard matches correctly
3. **Check precedence** - Deny rules override allow rules
4. **Check scope** - Global vs project-specific
5. **Reload Claude Code** - Changes require restart

### Too Many Prompts

If Claude keeps asking for permission:

1. Identify the exact tool and parameters being used
2. Add a specific permission pattern
3. Consider using wildcards for flexibility

### Security vs Convenience

Balance security with productivity:

- **Tight permissions** = More secure, more prompts
- **Loose permissions** = Fewer prompts, less security

For personal projects on your own machine, looser permissions are often fine.

## Examples from Real Projects

### NixOS Configuration Project

```json
{
  "permissions": {
    "allow": [
      "WebFetch(domain:github.com)",
      "WebFetch(domain:nixos.org)",
      "WebFetch(domain:search.nixos.org)",
      "WebFetch(domain:nix-community.github.io)",
      "Bash(command:nix*)",
      "Bash(command:nixos-rebuild test*)",
      "Bash(command:home-manager build*)",
      "Read(file_path://home/user/nixfiles/**)",
      "Write(file_path://home/user/nixfiles/**)",
      "Edit(file_path://home/user/nixfiles/**)"
    ]
  }
}
```

### Docker Compose Service Repository

```json
{
  "permissions": {
    "allow": [
      "WebFetch(domain:github.com)",
      "WebFetch(domain:hub.docker.com)",
      "WebSearch",
      "Bash(command:docker compose*)",
      "Bash(command:docker inspect*)",
      "Bash(command:docker logs*)",
      "Bash(command:cat*)",
      "Bash(command:ls*)",
      "mcp__unraid-ssh__docker_logs",
      "mcp__unraid-ssh__docker_inspect",
      "Read(file_path://home/user/Development/DockerUnraid/**)"
    ]
  }
}
```

## Best Practices

1. **Start restrictive** - Add permissions as needed
2. **Use project-specific** - Keep global permissions minimal
3. **Document reasons** - Comment why permissions are needed
4. **Review regularly** - Remove unused permissions
5. **Test in safe environment** - Verify permissions work as expected
6. **Use version control** - Track permission changes in git/jj

## Common Permission Patterns Reference

### Web Resources
```json
"WebFetch(domain:github.com)"
"WebFetch(domain:docs.*.com)"
"WebSearch"
```

### File Operations
```json
"Read(file_path://home/user/Development/**)"
"Write(file_path://home/user/Development/project/**)"
"Edit(file_path://home/user/Development/project/**)"
```

### Version Control
```json
"Bash(command:jj log*)"
"Bash(command:jj diff*)"
"Bash(command:jj describe*)"
"Bash(command:git status)"
"Bash(command:git log*)"
```

### Development Tools
```json
"Bash(command:npm*)"
"Bash(command:cargo*)"
"Bash(command:go*)"
"Bash(command:python*)"
"Bash(command:make*)"
```

### System Information
```json
"Bash(command:ls*)"
"Bash(command:cat*)"
"Bash(command:grep*)"
"Bash(command:find*)"
"Bash(command:du*)"
"Bash(command:df*)"
```

## Getting Help

If you're unsure about permissions:

1. Start with minimal permissions
2. Let Claude Code prompt you when it needs access
3. Grant permissions one at a time
4. Add to config file once you're confident
