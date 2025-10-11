- When confidence is below 80%, ask for clarification with multiple choice options when appropriate.

## Development Tools and setup

- Always use jj rather than git. Never run git commands directly when a jj command will do.
- Devbox is my preferred way to manage dependencies
- Add packages to devbox one at a time using `devbox add` (adding multiple packages exceeds the 120s timeout).
- Run all unit tests whenever making logic changes to the code. It should be the common final task
- **Environment Variables**: Test env vars in commands initially, then make permanent in `devbox.json` `init_hook` or `.devbox/setup-*.sh` scripts. Never leave env vars in repeated command invocations.
- **CRITICAL - Server Access**: NEVER use ssh, scp, or any direct remote access tools to access servers
  - SSH keys and servers are personal and off-limits
  - ONLY use MCP tools that have been explicitly provided for server access
  - If MCP tools don't provide needed functionality, ask the user to run commands manually
  - This is a hard boundary - no exceptions

## Security Best Practices

- **API Keys and Secrets**: NEVER print or echo API keys in commands or logs
  - Avoid displaying sensitive credentials in debug output
  - Use `.gitignore` to prevent committing secrets
  - Store secrets in `./secrets/` directory with restrictive permissions (600)
  - When testing API integrations, verify the connection works without logging the key value

## NixOS/Home Manager Configuration

- **Always use the nixos-config-expert agent** for NixOS/Home Manager changes: adding packages, modifying services, updating flake inputs, or editing `.nix` files
- **Exception**: devbox-related tasks should NOT use nixos-config-expert - handle those directly
