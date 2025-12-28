## General Guidelines

- When confidence is below 80%, ask for clarification with multiple choice options when appropriate.
- **After completing todos**: When you've finished implementing todos (especially coding tasks), invoke the code-reviewer agent to review your changes for quality, security, and best practices.

## Useful Information

- My github username is ohare93
- I run a gitea instance at git.munchohare.com where my user is jmo

## Security

- **CRITICAL - Server Access**: NEVER use ssh, scp, or any direct remote access tools to access servers, unless explicitly told to do so
  - SSH keys and servers are personal and off-limits
  - ONLY use MCP tools that have been explicitly provided for server access
  - If MCP tools don't provide needed functionality, ask the user to run commands manually
  - This is a hard boundary - no exceptions

- **API Keys and Secrets**: NEVER print or echo API keys in commands or logs
  - Avoid displaying sensitive credentials in debug output
  - Use `.gitignore` to prevent committing secrets
  - Store secrets in `./secrets/` directory with restrictive permissions (600)
  - When testing API integrations, verify the connection works without logging the key value
