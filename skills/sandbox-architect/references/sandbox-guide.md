# Claude Code Sandbox Configuration Reference

## Overview

Claude Code Sandbox provides OS-level isolation for bash commands, protecting your system from:
- Prompt injection attacks
- Supply chain attacks via dependencies
- Accidental file modifications outside project
- Unauthorized network access

## Configuration File Locations

Files are loaded in order (later overrides earlier):

```
~/.claude/settings.json          # Global user settings (lowest)
.claude/settings.json            # Project settings (committed)
.claude/settings.local.json      # Personal overrides (gitignored)
CLI arguments                    # Command-line flags
Enterprise policy                # Organization-wide (highest)
```

## Complete Settings Reference

### sandbox.enabled
- **Type**: boolean
- **Default**: false
- **Purpose**: Master switch for sandboxing

### sandbox.autoAllowBashIfSandboxed
- **Type**: boolean
- **Default**: true
- **Purpose**: When true, sandboxed commands run without prompting (Auto-allow mode)

### sandbox.excludedCommands
- **Type**: string[]
- **Default**: []
- **Purpose**: Commands that ALWAYS run OUTSIDE sandbox
- **Common entries**: `["docker", "docker-compose", "podman", "kubectl", "helm", "wp-env"]`

### sandbox.allowUnsandboxedCommands
- **Type**: boolean
- **Default**: true
- **Purpose**: When sandbox fails, allow retry outside sandbox with user prompt
- **Security note**: Set to `false` for fail-closed security

### sandbox.network.allowLocalBinding
- **Type**: boolean
- **Default**: false
- **Platform**: macOS only
- **Purpose**: Allow processes to bind/listen on localhost ports
- **Required for**: Dev servers (Vite, Next.js, Django runserver, etc.)

### sandbox.network.allowUnixSockets
- **Type**: string[]
- **Default**: []
- **Purpose**: Allow access to specific Unix socket paths
- **Common use**: SSH agent socket for git SSH authentication
- **Example**: `["/run/user/1000/ssh-agent.socket"]`

### sandbox.network.allowAllUnixSockets
- **Type**: boolean
- **Default**: false
- **Purpose**: Allow ALL Unix sockets (dangerous, not recommended)

### sandbox.network.httpProxyPort / socksProxyPort
- **Type**: number
- **Purpose**: Use custom proxy for network filtering

### sandbox.enableWeakerNestedSandbox
- **Type**: boolean
- **Default**: false
- **Platform**: Linux only
- **Purpose**: Enable sandboxing inside unprivileged containers
- **Security note**: Significantly weakens sandbox, only use with other isolation

## Permission Rules

### Rule Precedence

```
DENY > ASK > ALLOW
```

Deny rules always win, regardless of order.

### Syntax

```json
{
    "permissions": {
        "allow": ["Tool(pattern)"],
        "deny": ["Tool(pattern)"],
        "ask": ["Tool(pattern)"]
    }
}
```

### Common Patterns

```json
// File protection
"Read(./.env)"           // Exact file
"Read(./.env.*)"         // Pattern match
"Read(./secrets/**)"     // Directory recursive
"Read(~/.ssh/**)"        // Home directory

// Bash commands
"Bash(npm:*)"            // npm with any args
"Bash(git status)"       // Exact command
"Bash(git push:*)"       // git push with args
"Bash(curl:*)"           // curl with any args

// Network (WebFetch)
"WebFetch(domain:github.com)"
"WebFetch(domain:registry.npmjs.org)"
```

### Important Limitations

- Domain wildcards (`*.example.com`) are NOT supported
- Each subdomain needs separate rule
- Bash patterns can be bypassed (prefer WebFetch for network control)

## Two Systems: Sandbox vs Permissions

| Aspect | Sandbox | Permissions |
|--------|---------|-------------|
| Controls | WHERE bash executes | WHAT Claude can do |
| Enforcement | OS kernel | Application level |
| Applies to | Bash only | All tools |
| Child processes | Inherited | No |
| Prompt injection resistant | Yes | Partially |

## Platform-Specific Notes

### Linux (Bubblewrap)

- Uses Linux namespaces for isolation
- Network namespace completely removed
- Requires: `apt install bubblewrap socat`

### macOS (Seatbelt)

- Uses Apple's sandbox-exec
- `allowLocalBinding` needed for dev servers
- Path-based restrictions

## Common Domain Allowlists

### Node.js/npm
```json
"WebFetch(domain:registry.npmjs.org)",
"WebFetch(domain:registry.yarnpkg.com)"
```

### Python/pip
```json
"WebFetch(domain:pypi.org)",
"WebFetch(domain:files.pythonhosted.org)"
```

### Rust/Cargo
```json
"WebFetch(domain:crates.io)",
"WebFetch(domain:static.crates.io)",
"WebFetch(domain:index.crates.io)"
```

### Go
```json
"WebFetch(domain:proxy.golang.org)",
"WebFetch(domain:sum.golang.org)"
```

### PHP/Composer
```json
"WebFetch(domain:packagist.org)",
"WebFetch(domain:repo.packagist.org)"
```

### Common Services
```json
"WebFetch(domain:github.com)",
"WebFetch(domain:api.github.com)",
"WebFetch(domain:raw.githubusercontent.com)"
```

## Threat Model

### Protected Against
- File exfiltration via prompt injection (OS-enforced)
- System modification outside project
- Supply chain attacks in postinstall scripts
- Unauthorized network connections

### Partially Protected
- Exfiltration via allowed domains (be selective)
- Domain fronting through CDNs

### Not Protected
- Damage to project files (use version control)
- Social engineering (you approve it)
- Attacks on sandbox itself (keep OS updated)

## Troubleshooting Quick Reference

| Symptom | Cause | Fix |
|---------|-------|-----|
| Dev server can't bind port | `allowLocalBinding: false` | Set to `true` |
| Docker fails | Sandbox incompatible | Add to `excludedCommands` |
| Git push SSH fails | Socket blocked | Add socket to `allowUnixSockets` |
| npm install network error | Domain blocked | Add registry to WebFetch allow |
| Jest watch fails | watchman incompatible | Use `--no-watchman` flag |
| Commands prompt despite auto-allow | Regular permissions mode | Run `/sandbox`, select Auto-allow |

## Finding SSH Agent Socket

```bash
echo $SSH_AUTH_SOCK
# Common paths:
# Linux: /run/user/1000/ssh-agent.socket
# macOS: /private/tmp/com.apple.launchd.*/Listeners
```
