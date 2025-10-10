# Language-Specific Permission Templates Guide

This guide helps you choose the right permission template for your project based on language and tech stack.

## Quick Selection Guide

| Language/Stack | Template File | When to Use |
|---------------|---------------|-------------|
| **Generic** | `settings.local.json.template` | New projects, unsure of needs, or as starting point |
| **Elm** | `settings-elm.json.template` | Elm frontend applications |
| **Go** | `settings-go.json.template` | Go applications and services |
| **Rust** | `settings-rust.json.template` | Rust applications |
| **Python** | `settings-python.json.template` | Python scripts and applications |
| **C#/.NET** | `settings-csharp.json.template` | C# with Podman/container testing |
| **Docker/Infra** | `settings-docker.json.template` | Docker compose projects, infrastructure |

## Template Details

### Generic Template (`settings.local.json.template`)

**Use when:**
- Starting a new project and unsure of specific needs
- Working with multiple languages
- Project doesn't fit into specific language categories
- As a base to build upon

**Includes:**
- Basic file operations: `mkdir`, `ls`, `cat`, `grep`, `find`
- Version control: `jj log`, `jj diff`, `jj describe`, `jj status`
- Package management: `devbox add`, `devbox run`
- Web research: `WebFetch(domain:github.com)`, `WebSearch`
- File access: `Read(//home/jmo/Development/**)`

**Customize by adding:**
- Language-specific build/test commands
- Additional web domains for documentation
- Project-specific bash commands

### Elm Template (`settings-elm.json.template`)

**Use when:**
- Building Elm frontend applications
- Need to compile, test, and format Elm code
- Working with Elm toolchain

**Specific permissions:**
```json
"Bash(elm make:*)",
"Bash(elm-test:*)",
"Bash(elm-format:*)",
"Bash(beepcomplete)",
"WebFetch(domain:package.elm-lang.org)"
```

**Common use case:** Frontend web applications with Elm

### Go Template (`settings-go.json.template`)

**Use when:**
- Building Go services or CLI tools
- Need to build, test, and manage Go modules
- Developing Go applications

**Specific permissions:**
```json
"Bash(go build:*)",
"Bash(go test:*)",
"Bash(go mod:*)",
"Bash(go run:*)",
"WebFetch(domain:pkg.go.dev)"
```

**Common use case:** Backend services, CLI tools, file management utilities

### Rust Template (`settings-rust.json.template`)

**Use when:**
- Building Rust applications
- Need to use Cargo for builds and tests
- Working with Rust crates

**Specific permissions:**
```json
"Bash(cargo build:*)",
"Bash(cargo test:*)",
"Bash(cargo run:*)",
"Bash(cargo add:*)",
"WebFetch(domain:docs.rs)",
"WebFetch(domain:crates.io)"
```

**Common use case:** System tools, performance-critical applications, audio processing

### Python Template (`settings-python.json.template`)

**Use when:**
- Building Python applications or scripts
- Need to run Python code and tests
- Using pip for dependencies

**Specific permissions:**
```json
"Bash(python:*)",
"Bash(python3:*)",
"Bash(python -m py_compile:*)",
"Bash(pytest:*)",
"Bash(pip install:*)",
"WebFetch(domain:docs.python.org)",
"WebFetch(domain:pypi.org)"
```

**Common use case:** Scripts, automation, API integrations, data processing

### C#/.NET Template (`settings-csharp.json.template`)

**Use when:**
- Building .NET applications
- Using Podman for container testing
- Need dotnet CLI commands

**Specific permissions:**
```json
"Bash(dotnet build:*)",
"Bash(dotnet test:*)",
"Bash(dotnet run:*)",
"Bash(dotnet add package:*)",
"Bash(DOCKER_HOST=unix:///run/user/1000/podman/podman.sock dotnet test:*)",
"Bash(podman compose:*)",
"Bash(podman build:*)",
"WebFetch(domain:learn.microsoft.com)",
"WebFetch(domain:docs.microsoft.com)"
```

**Common use case:** .NET services with containerized dependencies, integration tests

**Important:** Includes special `DOCKER_HOST` variable for Podman integration with dotnet test

### Docker/Infrastructure Template (`settings-docker.json.template`)

**Use when:**
- Managing Docker Compose services
- Building and pushing container images
- Infrastructure/DevOps work
- Working with Unraid via MCP

**Specific permissions:**
```json
"Bash(docker build:*)",
"Bash(docker compose:*)",
"Bash(docker tag:*)",
"Bash(docker push:*)",
"Bash(docker images:*)",
"Bash(docker ps:*)",
"Bash(docker logs:*)",
"mcp__unraid-ssh__docker_list_containers",
"mcp__unraid-ssh__docker_logs",
"mcp__unraid-ssh__docker_inspect",
"mcp__unraid-ssh__system_list_files",
"WebFetch(domain:hub.docker.com)",
"WebFetch(domain:docs.docker.com)"
```

**Common use case:** Docker Compose stacks, container registry management, Unraid services

**Important:** Includes MCP tools for remote Unraid server management

## Combining Templates

Sometimes projects need permissions from multiple templates. Here's how to combine them:

### Example: Rust + Docker

For a Rust project that builds Docker images:

1. Start with `settings-rust.json.template`
2. Add Docker-specific permissions from `settings-docker.json.template`:
   ```json
   "Bash(docker build:*)",
   "Bash(docker compose:*)",
   "Bash(docker tag:*)",
   "Bash(docker push:*)"
   ```

### Example: Python + Docker

For Python services running in containers:

1. Start with `settings-python.json.template`
2. Add Docker permissions for running tests in containers
3. Consider adding `docker-compose` for integration tests

### Example: Go + MCP Server

For Go projects that also manage infrastructure:

1. Start with `settings-go.json.template`
2. Add relevant MCP permissions from Docker template if managing remote services

## Customization Tips

### Adding New Permissions

When adding permissions to any template:

1. **Be specific**: Use wildcards (`*`) for arguments, but be specific about commands
   ```json
   "Bash(mycommand:*)"  // Good: allows all arguments
   "Bash(*)"             // Bad: too broad
   ```

2. **Group by purpose**: Keep related permissions together
   ```json
   // Build tools
   "Bash(cargo build:*)",
   "Bash(cargo test:*)",

   // Version control
   "Bash(jj log:*)",
   "Bash(jj diff:*)"
   ```

3. **Document non-obvious permissions**: Add comments for complex permissions
   ```json
   // Special DOCKER_HOST for Podman integration
   "Bash(DOCKER_HOST=unix:///run/user/1000/podman/podman.sock dotnet test:*)"
   ```

### Web Domain Permissions

Always include relevant documentation domains for your stack:

- **Elm**: `package.elm-lang.org`
- **Go**: `pkg.go.dev`
- **Rust**: `docs.rs`, `crates.io`
- **Python**: `docs.python.org`, `pypi.org`
- **C#**: `learn.microsoft.com`, `docs.microsoft.com`
- **Docker**: `hub.docker.com`, `docs.docker.com`

**Always include**: `github.com`, `raw.githubusercontent.com` for accessing code and examples

### File Access Patterns

Most templates include:
```json
"Read(//home/jmo/Development/**)"
```

Expand this for specific needs:
```json
"Read(//home/jmo/Development/**)",
"Read(//home/jmo/.config/myapp/**)",  // App config files
"Read(//nix/store/**)"                 // Nix store for C# projects
```

## Common Permission Patterns

### Testing Commands

Most language templates follow this pattern:
```json
"Bash(language-tool test:*)"  // e.g., go test, cargo test, pytest
```

**Always include**: Testing is a universal requirement (see global instructions)

### Build Commands

Standard pattern:
```json
"Bash(language-tool build:*)"  // e.g., go build, cargo build, elm make
```

### Package Management

Each language has its own:
- **Elm**: `elm install`
- **Go**: `go mod`, `go get`
- **Rust**: `cargo add`
- **Python**: `pip install`
- **C#**: `dotnet add package`

**Note**: All templates also include `devbox add` and `devbox run` for system-level dependencies

### Format/Lint Commands

Add when relevant:
```json
"Bash(elm-format:*)",
"Bash(cargo fmt:*)",
"Bash(go fmt:*)",
"Bash(black:*)",      // Python
```

## Template Migration

### From Generic to Specific

When your project matures:

1. Start with `settings.local.json.template`
2. As needs become clear, switch to language-specific template
3. Copy any custom permissions you added
4. Remove unused permissions for security

### From Specific to Combined

When project complexity grows:

1. Start with primary language template
2. Identify additional tool requirements
3. Add specific permissions from other templates
4. Test that all workflows still function
5. Remove any unused permissions

## Security Considerations

### Principle of Least Privilege

Only grant permissions actually needed:

❌ **Don't do this:**
```json
"Bash(*)"  // Way too broad
```

✅ **Do this:**
```json
"Bash(cargo test:*)",
"Bash(cargo build:*)"
```

### Review Regularly

Periodically review your `settings.local.json`:
- Remove permissions for abandoned features
- Tighten overly-broad permissions
- Add comments for non-obvious permissions

### Dangerous Permissions to Avoid

Unless absolutely necessary, avoid:
- `Bash(rm:*)` - File deletion
- `Bash(sudo:*)` - Elevated privileges
- `Bash(ssh:*)` - Remote access (use MCP tools instead)
- Overly broad file reads outside Development directory

## Template Maintenance

### Keeping Templates Updated

As you discover new patterns:

1. Update the template in this repository
2. Sync changes to active projects: `./scripts/sync.sh`
3. Update this guide with new learnings
4. Consider adding patterns to `docs/best-practices.md`

### Project-Specific Additions

Some permissions should stay in individual projects:
- Project-specific build scripts
- Custom devbox commands
- Specialized MCP tools
- Internal tool permissions

**Rule of thumb**: If 3+ projects need it, add to template. Otherwise, keep it project-specific.

## Examples from Real Projects

### audio-thing (Rust + Docker)

Combined Rust and Docker templates for audio processing service with containerization:
```json
{
  "permissions": {
    "allow": [
      // Rust tooling
      "Bash(cargo build:*)",
      "Bash(cargo test:*)",

      // Docker for deployment
      "Bash(docker build:*)",
      "Bash(docker tag:*)",

      // Standard inclusions
      "Bash(jj log:*)",
      "Read(//home/jmo/Development/audio-thing/**)"
    ]
  }
}
```

### DockerUnraid (Infrastructure)

Pure Docker template with MCP tools for remote server management:
```json
{
  "permissions": {
    "allow": [
      "Bash(docker compose:*)",
      "Bash(docker ps:*)",
      "Bash(docker logs:*)",

      // MCP tools for Unraid
      "mcp__unraid-ssh__docker_list_containers",
      "mcp__unraid-ssh__docker_logs",
      "mcp__unraid-ssh__system_list_files",

      "Read(//home/jmo/Development/DockerUnraid/**)"
    ]
  }
}
```

### noticer (C# + Podman)

C# template with Podman for integration tests:
```json
{
  "permissions": {
    "allow": [
      "Bash(dotnet test:*)",
      "Bash(dotnet build:*)",

      // Podman integration for tests
      "Bash(DOCKER_HOST=unix:///run/user/1000/podman/podman.sock dotnet test:*)",
      "Bash(podman compose:*)",

      "Read(//home/jmo/Development/noticer/**)",
      "Read(//nix/store/**)"  // Needed for C# .NET runtime
    ]
  }
}
```

## Getting Help

If you're unsure which template to use:

1. Start with `settings.local.json.template`
2. Add permissions as you need them
3. After a few coding sessions, see which pattern emerges
4. Switch to the appropriate language-specific template
5. Refer to `docs/permissions-guide.md` for detailed permission syntax

## Related Documentation

- `docs/permissions-guide.md` - Comprehensive permissions syntax guide
- `docs/global-instructions.md` - Universal development preferences
- `docs/best-practices.md` - Language-specific gotchas and solutions
- `README.md` - Repository overview and quick start
