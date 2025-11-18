# Best Practices for Claude Code

This document outlines lessons learned and best practices for working with Claude Code in this setup.

## Development Workflow

### Version Control
- **Always use `jj`** - Never use raw git commands. The source-control-expert agent handles all version control operations.
- **Write descriptive commit messages** - Use conventional commit format (e.g., `feat:`, `fix:`, `docs:`).
- **Commit frequently** - Small, atomic commits make it easier to track changes and revert if needed.

### Testing and Validation
- **Run tests after logic changes** - Always execute tests after modifying code logic to catch regressions early.
- **Use language-specific tools**:
  - Elm: `elm-test` and `elm-review`
  - Go: Standard testing tools
  - Rust: `cargo test`
- **Validate builds** - For NixOS configurations, always test builds before deploying.

### Dependency Management
- **Prefer devbox** - Use devbox for dependency management when possible.
- **Fallback to nix** - Use `nix develop` as a fallback if devbox isn't suitable.
- **Pin versions** - Lock dependency versions for reproducibility.

## NixOS Configuration

### Flakes-First Approach
- **Always use flakes** - The nixos-config-expert agent enforces flakes-only configurations.
- **Test before applying** - Build configurations before applying them to production systems.
- **Document changes** - Add comments explaining non-obvious configuration choices.

### Reproducibility
- **Lock inputs** - Use `flake.lock` to ensure reproducible builds.
- **Avoid imperative changes** - Keep all system configuration in declarative files.
- **Version control everything** - Track all configuration files in version control.

## Docker and Container Management

### Image Handling
- **Use skopeo** - Always use `skopeo` to check Docker image versions; never scrape websites.
- **Tag semantically** - Use semantic versioning for container tags (e.g., `v1.2.3`).
- **Document registries** - Clearly specify which registry images come from.

### Pre-built Images
- **Avoid unnecessary rebuilds** - When using images from registries, configure to use existing builds rather than rebuilding.
- **Reference by digest** - Use image digests for production to ensure exact versions.

## Security Practices

### Access Control
- **No SSH/SCP** - Never use SSH or SCP to access servers directly.
- **Use MCP tools** - Leverage MCP servers (Gitea, filesystem, etc.) for server interactions.
- **Environment variables for secrets** - Store API keys and tokens in environment variables (e.g., `GITEA_ACCESS_TOKEN`).

### Sensitive Data
- **Never commit secrets** - Use `.gitignore` patterns to exclude credential files.
- **Use environment-specific configs** - Leverage `.local` files for machine-specific settings (already in `.gitignore`).

## Agent Usage

### When to Use Specialized Agents
- **nixos-config-expert** - For all NixOS and Home Manager configurations (uses Claude Opus for complex reasoning).
- **source-control-expert** - For jj operations, container registry work, and Gitea interactions (uses Claude Sonnet for balanced performance).

### Agent Invocation
- **Let Claude Code auto-invoke** - Agents should automatically trigger based on task context.
- **Provide clear context** - Give enough information for the agent to understand the full task.
- **Review agent output** - Always verify agent-generated configurations before applying.

## Project Organization

### Project-Specific Instructions
- **Use CLAUDE.md files** - Create project-specific `CLAUDE.md` files in each repository for local context.
- **Use templates** - Leverage the templates in `templates/` for new projects:
  - `CLAUDE-project.md.template` for general projects
  - `CLAUDE-docker.md.template` for Dockerized services

### Permissions Management
- **Configure `.claude/settings.local.json`** - Set appropriate permissions for Claude Code in each project.
- **Use language-specific templates** - Start with templates from `templates/settings-*.json.template`.
- **Review permissions regularly** - Audit what Claude Code can do in each project.

## MCP Server Integration

### Available Servers
- **filesystem** - Access to `/home/jmo/Development` (⚠️ customize this path in `.mcp.json`) and `/tmp` for file operations.
- **gitea** - Integration with `git.munchohare.com` for repository management.
- **sqlite** - Database operations (configured for `/tmp/test.db`).
- **playwright** - Browser automation for testing.
- **serena** - Semantic code analysis with language server integration.

### Usage Tips
- **Check MCP availability** - Verify MCP servers are running before attempting operations.
- **Handle errors gracefully** - MCP server failures should fall back to alternative approaches.
- **Respect access boundaries** - Only access paths and resources explicitly configured in MCP settings.

## Common Pitfalls

### Avoid These Mistakes
1. **Using git directly** - Always use `jj` instead.
2. **Skipping tests** - Don't commit logic changes without running tests.
3. **Web scraping for versions** - Use `skopeo` for Docker images.
4. **SSH access** - Use MCP tools instead of direct SSH.
5. **Hardcoding paths** - Use relative paths or environment variables.
6. **Forgetting to build** - For NixOS changes, always test builds before applying.

### Troubleshooting
- **MCP connection issues** - Check that required environment variables are set (e.g., `GITEA_ACCESS_TOKEN`).
- **Permission denied** - Review `.claude/settings.local.json` permissions.
- **Command not found** - Ensure devbox or nix shell is activated.
- **Build failures** - Check flake inputs are up to date with `nix flake update`.

## Documentation Maintenance

### Keep Docs Updated
- **Update global-instructions.md** - Add new conventions and preferences as they emerge.
- **Document new workflows** - Add slash commands for frequently repeated tasks.
- **Version control documentation** - Track all doc changes in git.

### Optimization
- **Use /optimise-doc** - Run the optimization command on documentation to improve clarity.
- **Remove outdated info** - Regularly review and remove obsolete documentation.
- **Link related docs** - Cross-reference related documentation files.

## Workflow Commands

### Slash Commands Available
- **/jj-describe-all** - Auto-describe jj commits in conventional format.
- **/juggle-plan-all** - Analyze juggler balls and create execution plans.
- **/optimise-doc** - Optimize documentation for clarity and conciseness.
- **/split-plan** - Split plans into workpackages for specialized agents.

### Creating New Commands
- **Keep commands focused** - Each command should do one thing well.
- **Document clearly** - Add comprehensive descriptions for command behavior.
- **Register in marketplace** - Add new commands to `.claude-plugin/marketplace.json`.

## Performance Tips

### Optimize Claude Code Usage
- **Provide sufficient context** - Include relevant file paths and code snippets.
- **Use caching** - Leverage Claude Code's caching for repeated operations.
- **Batch related tasks** - Group similar operations to reduce context switching.

### Resource Management
- **Close unused MCP connections** - Don't keep unnecessary MCP servers running.
- **Clean up temporary files** - Use `/tmp` for temporary data and clean up after.
- **Monitor resource usage** - Be aware of disk space and memory constraints.

## Continuous Improvement

### Iterative Enhancement
- **Capture new patterns** - When you solve a problem, consider making it reusable.
- **Create templates** - For repetitive project setups, create new templates.
- **Share learnings** - Document lessons learned in this file.

### Regular Maintenance
- **Update dependencies** - Keep MCP servers and tools up to date.
- **Review and prune** - Remove unused agents, commands, or configurations.
- **Test periodically** - Validate that all MCP servers and commands still work.

---

**Last Updated**: 2025-11-18

For questions or suggestions, refer to the main [README.md](../README.md).
