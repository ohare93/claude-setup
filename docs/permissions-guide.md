# Claude Code Permissions Guide

This guide explains how to configure permissions for Claude Code using `.claude/settings.local.json` files.

## Overview

Claude Code uses a permissions system to control what operations it can perform. Permissions are configured in `.claude/settings.local.json` files, which should be placed in the root of each project.

### Why Permissions Matter

- **Security**: Limit Claude Code's access to only what's needed for the project.
- **Safety**: Prevent accidental destructive operations.
- **Clarity**: Make it explicit what Claude Code can and cannot do.

## Permission Format

Permissions are specified in JSON format with `allow` and `deny` arrays:

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Permission(pattern:value)"
    ],
    "deny": [
      "Permission(pattern:value)"
    ]
  }
}
```

## Common Permission Patterns

### Web Access

Allow Claude Code to fetch content from specific domains:

```json
"WebFetch(domain:github.com)",
"WebFetch(domain:raw.githubusercontent.com)",
"WebSearch"
```

**Best Practice**: Only allow domains you trust and need for your project.

### File System Access

Control which directories Claude Code can read:

```json
"Read(//home/jmo/Development/**)",
"Read(/tmp/**)"
```

**Note**: Use absolute paths with `//` prefix. The `**` wildcard matches all subdirectories.

**Best Practice**: Limit read access to your project directory and `/tmp` for temporary files.

### Bash Commands

Grant permission for specific bash commands:

```json
"Bash(mkdir:*)",
"Bash(ls:*)",
"Bash(cat:*)",
"Bash(grep:*)",
"Bash(find:*)"
```

**Wildcard Usage**:
- `*` matches any arguments (e.g., `Bash(ls:*)` allows `ls -la`, `ls /path`, etc.)
- Without `*`, only the exact command is allowed

**Best Practice**: Be specific about which commands are allowed. Avoid overly broad permissions.

## Language-Specific Permissions

### Elm Projects

```json
"Bash(elm make:*)",
"Bash(elm-test:*)",
"Bash(elm-format:*)",
"Bash(elm install:*)",
"Bash(elm repl:*)",
"Bash(timeout 30 elm-test:*)",
"Bash(timeout 60 elm-test:*)",
"Bash(timeout 120 elm-test:*)"
```

### Go Projects

```json
"Bash(go build:*)",
"Bash(go test:*)",
"Bash(go mod:*)",
"Bash(go fmt:*)",
"Bash(go vet:*)",
"Bash(go run:*)"
```

### Rust Projects

```json
"Bash(cargo build:*)",
"Bash(cargo test:*)",
"Bash(cargo run:*)",
"Bash(cargo check:*)",
"Bash(cargo fmt:*)",
"Bash(cargo clippy:*)"
```

### Python Projects

```json
"Bash(python:*)",
"Bash(python3:*)",
"Bash(pip install:*)",
"Bash(pytest:*)",
"Bash(black:*)",
"Bash(flake8:*)",
"Bash(mypy:*)"
```

### C# Projects

```json
"Bash(dotnet build:*)",
"Bash(dotnet test:*)",
"Bash(dotnet run:*)",
"Bash(dotnet add:*)",
"Bash(dotnet restore:*)"
```

### Docker Projects

```json
"Bash(docker build:*)",
"Bash(docker run:*)",
"Bash(docker-compose:*)",
"Bash(skopeo:*)"
```

**Important**: For Docker image version checking, always use `skopeo` instead of web scraping.

## Version Control Permissions

### Jujutsu (jj)

For this setup, **always use jj** instead of git:

```json
"Bash(jj log:*)",
"Bash(jj diff:*)",
"Bash(jj describe:*)",
"Bash(jj status:*)",
"Bash(jj new:*)",
"Bash(jj commit:*)",
"Bash(jj split:*)"
```

**Best Practice**: Grant read-only jj commands (`log`, `diff`, `status`) by default. Only add write commands (`commit`, `split`) if needed for the project.

## Devbox Permissions

If using devbox for dependency management:

```json
"Bash(devbox add:*)",
"Bash(devbox run:*)",
"Bash(devbox shell:*)"
```

## NixOS Permissions

For NixOS configuration projects:

```json
"Bash(nix build:*)",
"Bash(nix develop:*)",
"Bash(nix flake:*)",
"Bash(nixos-rebuild:*)"
```

**Warning**: Be cautious with `nixos-rebuild` as it can modify system configuration.

## Using Templates

This repository provides pre-configured permission templates in the `templates/` directory:

### Available Templates

1. **`settings.local.json.template`** - Base template with minimal permissions
2. **`settings-elm.json.template`** - Elm project permissions
3. **`settings-go.json.template`** - Go project permissions
4. **`settings-rust.json.template`** - Rust project permissions
5. **`settings-python.json.template`** - Python project permissions
6. **`settings-csharp.json.template`** - C# project permissions
7. **`settings-docker.json.template`** - Docker project permissions

### How to Use Templates

1. **Choose the right template** for your project language/type
2. **Copy** the template to your project:
   ```bash
   cp ~/claude-setup/templates/settings-elm.json.template \
      /path/to/project/.claude/settings.local.json
   ```
3. **Customize** the permissions for your specific needs
4. **Update paths** - Replace `/home/jmo/Development` with your actual project path

### Template Selection Guide

See `templates/LANGUAGE-GUIDE.md` for detailed guidance on choosing the right template.

## Advanced Permission Patterns

### Conditional Permissions

You can combine multiple patterns for fine-grained control:

```json
"Bash(timeout 30 elm-test:*)",
"Bash(timeout 60 elm-test:*)",
"Bash(timeout 120 elm-test:*)"
```

This allows `elm-test` with specific timeout values.

### Deny List

Use the `deny` array to explicitly block operations:

```json
{
  "permissions": {
    "allow": ["Bash(rm:*)"],
    "deny": ["Bash(rm -rf:/)"]
  }
}
```

**Best Practice**: Use `deny` sparingly. It's safer to only allow what's needed rather than denying specific dangerous operations.

## Security Considerations

### Dangerous Permissions to Avoid

**Never grant blanket permissions** like:
```json
"Bash(*)"  // DANGEROUS: Allows any bash command
"Read(//**)"  // DANGEROUS: Allows reading entire filesystem
```

### Safe Defaults

Start with minimal permissions and add as needed:

```json
{
  "permissions": {
    "allow": [
      "WebSearch",
      "Bash(ls:*)",
      "Bash(cat:*)",
      "Read(//path/to/your/project/**)"
    ],
    "deny": []
  }
}
```

### Protecting Sensitive Data

**Never allow access to**:
- `/home/user/.ssh`
- `/home/user/.aws`
- `/etc/passwd`
- Other directories containing credentials

**Use environment variables** for secrets instead of hardcoding them.

## Project-Specific Configuration

### Multi-Environment Setup

For projects with multiple environments (dev, staging, prod):

1. **Create `.claude/settings.local.json`** for development environment
2. **Use environment variables** for environment-specific values
3. **Never commit** `.claude/settings.local.json` to version control

The `.gitignore` pattern `*.local` ensures these files stay local.

### Team Collaboration

For team projects:

1. **Create `.claude/settings.example.json`** with safe defaults
2. **Document** required permissions in project README
3. **Let team members** customize their own `.claude/settings.local.json`
4. **Never share** actual `.claude/settings.local.json` files (they may contain local paths)

## Troubleshooting

### Permission Denied Errors

If Claude Code reports permission denied:

1. **Check `.claude/settings.local.json`** exists in your project root
2. **Verify** the required permission is in the `allow` array
3. **Ensure** the permission pattern matches (use `*` for wildcards)
4. **Check** file paths use absolute paths with `//` prefix

### Common Mistakes

**Mistake**: Using relative paths
```json
"Read(./src/**)"  // WRONG
```
**Fix**: Use absolute paths
```json
"Read(//home/jmo/Development/myproject/src/**)"  // CORRECT
```

**Mistake**: Forgetting wildcards
```json
"Bash(elm-test)"  // Only allows 'elm-test' with no arguments
```
**Fix**: Add wildcard for arguments
```json
"Bash(elm-test:*)"  // Allows 'elm-test' with any arguments
```

**Mistake**: Missing schema reference
```json
{
  "permissions": { ... }  // No schema
}
```
**Fix**: Include schema for validation
```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": { ... }
}
```

## Testing Permissions

### Verify Your Configuration

1. **Start Claude Code** in your project directory
2. **Request an operation** that requires permissions (e.g., "run tests")
3. **Check for errors** - permission denied means you need to update `settings.local.json`

### Iterative Approach

1. **Start minimal** - Grant only essential permissions
2. **Test workflow** - Try common tasks
3. **Add permissions as needed** - When blocked, add the specific permission
4. **Document** - Note why each permission is needed

## Best Practices Summary

1. ✅ **Use templates** as starting points
2. ✅ **Grant minimal permissions** needed for the project
3. ✅ **Use absolute paths** with `//` prefix
4. ✅ **Include schema** reference for validation
5. ✅ **Document** why permissions are needed
6. ✅ **Test** your configuration regularly
7. ❌ **Never commit** `.claude/settings.local.json` to version control
8. ❌ **Never grant** overly broad permissions
9. ❌ **Never allow** access to sensitive directories

## Additional Resources

- **Template Directory**: `~/claude-setup/templates/`
- **Language Guide**: `~/claude-setup/templates/LANGUAGE-GUIDE.md`
- **Global Instructions**: `~/claude-setup/docs/global-instructions.md`
- **Best Practices**: `~/claude-setup/docs/best-practices.md`

---

**Last Updated**: 2025-11-18

For questions or feedback, refer to the main [README.md](../README.md).
