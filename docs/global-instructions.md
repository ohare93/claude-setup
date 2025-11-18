## General Guidelines

- When confidence is below 80%, ask for clarification with multiple choice options when appropriate.
- **After completing todos**: When you've finished implementing todos (especially coding tasks), invoke the code-reviewer agent to review your changes for quality, security, and best practices.

## Docker

### Checking Image Versions

- **ALWAYS use `skopeo` to check Docker image versions** - never try to parse Docker Hub web pages
- `skopeo` works reliably with Docker Hub, Quay.io, GitHub Container Registry, and custom registries like Gitea

**List available tags:**

```bash
# Docker Hub
skopeo list-tags docker://username/image
skopeo list-tags docker://rommapp/romm

# Quay.io
skopeo list-tags docker://quay.io/organization/image

# GitHub Container Registry
skopeo list-tags docker://ghcr.io/owner/repo

# Custom registry (like Gitea)
skopeo list-tags docker://git.munchohare.com/jmo/image
```

**Inspect specific image/tag:**

```bash
# Get detailed image information including labels, architecture, layers
skopeo inspect docker://rommapp/romm:4.3.2
skopeo inspect docker://git.munchohare.com/jmo/audioseek-frontend:0.1.11
```

**Why skopeo over web scraping:**

- Reliable: Direct registry API access, not HTML parsing
- Fast: No JavaScript rendering or page loading
- Comprehensive: Works with all OCI-compliant registries
- Accurate: Gets data directly from registry without intermediaries

## Useful Information

- My github username is ohare93
- I run a gitea instance at git.munchohare.com where my user is jmo

## Security

- **CRITICAL - Server Access**: NEVER use ssh, scp, or any direct remote access tools to access servers
  - SSH keys and servers are personal and off-limits
  - ONLY use MCP tools that have been explicitly provided for server access
  - If MCP tools don't provide needed functionality, ask the user to run commands manually
  - This is a hard boundary - no exceptions

- **API Keys and Secrets**: NEVER print or echo API keys in commands or logs
  - Avoid displaying sensitive credentials in debug output
  - Use `.gitignore` to prevent committing secrets
  - Store secrets in `./secrets/` directory with restrictive permissions (600)
  - When testing API integrations, verify the connection works without logging the key value

## Development Tools

- Always use jj rather than git. Never run git commands directly when a jj command will do.
- Run all unit tests after making logic changes to the code

### Devbox

- Devbox is the preferred dependency manager; use it for new projects.
  - Existing projects from external sources may need to use their setup. `nix develop` is acceptable.
- Add packages to devbox one at a time using `devbox add` (adding multiple packages exceeds the 120s timeout).
- **Environment Variables**: Test env vars in commands initially, then make permanent in `devbox.json` `init_hook` or `.devbox/setup-*.sh` scripts. Never leave env vars in repeated command invocations.

## Specialized Workflows

### NixOS/Home Manager

- **Always use the nixos-config-expert agent** for NixOS/Home Manager changes: adding packages, modifying services, updating flake inputs, or editing `.nix` files
- **Exception**: devbox-related tasks should NOT use nixos-config-expert - handle those directly

### Elm

- Always use elm-test and elm-review.
