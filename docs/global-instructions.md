- I use jj rather than git
- Add packages to devbox one at a time, using the `devbox add` command, as it takes too long when adding that it may go over 2 mins.
- Devbox is my preferred way to manage dependencies
- Run all unit tests whenever making logic changes to the code. It should be the common final task
- **Environment Variables**: Minimize use of env variables in commands and make them permanent when they work:
  - It's OK to add env vars to commands initially to test if they work (easier for debugging)
  - Once confirmed working, immediately make them permanent via devbox `init_hook` in `devbox.json`
  - Create `.devbox/setup-*.sh` scripts that find dependencies dynamically (e.g., searching nix store)
  - This serves as documentation and ensures commands work for everyone
  - Never leave env vars in repeated command invocations - that's a sign they should be permanent
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

- **Always use the nixos-config-expert agent** for any NixOS or Home Manager configuration changes
- This includes: adding packages, modifying services, updating flake inputs, or any `.nix` file changes
- Keywords that should trigger nixos-config-expert: "install to nixfiles", "add to home manager", "nixos package", "home.packages", "nix install" (NOT devbox)
- **Exception**: devbox-related tasks should NOT use nixos-config-expert - handle those directly
