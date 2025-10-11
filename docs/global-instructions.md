## General Guidelines

- When confidence is below 80%, ask for clarification with multiple choice options when appropriate.

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
