# Documentation Charter

This document serves as a comprehensive index of all documentation in the claude-setup repository. Think of it as a map to navigate the documentation landscape.

## Core Documentation

### global-instructions.md
**Purpose**: System-wide guidelines and best practices for Claude Code usage
**Key Topics**:
- General guidelines and confidence thresholds
- Docker and container workflows (using skopeo)
- Security policies (server access, API keys)
- Development tools (jj, devbox)
- Specialized workflows (NixOS, Elm)

**When to Consult**: Anytime you need to understand project conventions or tool usage patterns

### best-practices.md
**Purpose**: Development workflow best practices and hard-won knowledge from real issues
**Key Topics**:
- Testing and verification workflows
- Common pitfalls and how to avoid them
- Tool-specific gotchas (Docker, Traefik, NixOS, etc.)
- Performance and optimization tips
- Debugging strategies

**When to Consult**: Before implementing complex features, when debugging issues, or when establishing new workflows

### permissions-guide.md
**Purpose**: Comprehensive guide for configuring Claude Code permissions
**Key Topics**:
- Permission system overview and hierarchy
- Global vs project-specific permissions
- Pre-approval patterns for common operations
- Security best practices
- Deny rules and permission overrides
- Troubleshooting permission issues

**When to Consult**: Setting up new projects, configuring security boundaries, or debugging permission-related errors

---

## Repository Structure

### /agents
**Purpose**: Custom agent definitions for specialized tasks
**Documentation**: `/agents/README.md`

**Available Agents**:
- **nixos-config-expert.md**: NixOS, Home Manager, Nix flakes expertise
- **source-control-expert.md**: Jujutsu (jj), container registries, Git workflows
- **code-reviewer.md**: Code quality, security, and best practices review
- **docs-maintainer.md**: Documentation maintenance, structure, and quality assurance

**When to Use**: Need specialized expertise for system configuration, version control, code review, or documentation maintenance

---

### /commands
**Purpose**: Custom slash commands for common workflows
**Documentation**: `/commands/README.md`

**Available Commands**:
- **jj-describe-all.md**: Describe all changes in jujutsu commits
- **juggle-plan-all.md**: Plan changes using juggle
- **optimise-doc.md**: Optimize documentation files
- **split-plan.md**: Split planning into manageable chunks

**When to Use**: Invoke these commands via `/command-name` in Claude Code

---

### /hooks
**Purpose**: Automated behavior improvements that run at specific trigger points
**Documentation**: `/hooks/README.md`

**Available Hooks**:
- **forced-eval-skill.md**: Dramatically improves skill activation reliability (84% vs 50% baseline)
  - Implements three-step protocol: EVALUATE → ACTIVATE → IMPLEMENT
  - Runs on user-prompt-submit trigger
  - Essential for ensuring skills activate consistently

**Key Features**:
- Automatic skill evaluation before every prompt
- Prevents skill bypassing and rationalization
- Comprehensive documentation in hooks/README.md
- Cross-reference: `.claude-plugin/hooks/stop.sh` for context/cost tracking

**When to Use**: Install hooks globally to improve Claude's behavior across all sessions. See hooks/README.md for installation instructions.

---

### /templates
**Purpose**: Reusable templates for common file types and configurations
**Documentation**: `/templates/README.md` (if exists)

**When to Use**: Starting new projects or creating standardized configurations

---

### /mcp-servers
**Purpose**: Model Context Protocol server configurations
**Documentation**: `/mcp-servers/README.md` - Comprehensive guide with 86+ tools

**Available Servers**:
- **filesystem.json**: Privacy-preserving file operations (read/write/search)
- **gitea.json**: Gitea repository management and API access
- **playwright.json**: Browser automation and web testing
- **serena.json**: Semantic code analysis via language servers (runs via Nix)
- **sqlite.json**: SQLite database operations and queries
- **code-mode**: Efficient multi-tool workflows (configured in `.mcp.json`)

**When to Use**: Setting up or configuring MCP integrations. See mcp-servers/README.md for detailed documentation and usage examples.

---

### /.claude-plugin
**Purpose**: Claude Code plugin configuration and hooks

**Key Files**:
- **marketplace.json**: Plugin manifest and configuration
- **hooks/stop.sh**: Stop hook for displaying context, cache, and cost information

**When to Use**: Understanding or modifying Claude Code integration

---

## Documentation Maintenance

### How to Add New Documentation

1. **Create the document** in the appropriate directory
2. **Update this CHARTER.md** with:
   - Document name and location
   - Purpose and key topics
   - When to consult it
3. **Update related README.md** files if applicable
4. **Run `/optimise-doc`** to ensure quality (if applicable)

### Documentation Standards

- **Use clear headers**: Make documents scannable
- **Include purpose statements**: Why does this doc exist?
- **Provide examples**: Show, don't just tell
- **Keep it current**: Update docs when behavior changes
- **Link related docs**: Create a web of knowledge

### When to Create New Documentation

- **Repeating patterns**: If you explain the same thing multiple times
- **Complex workflows**: Multi-step processes that need reference
- **Tool-specific guidance**: Unique usage patterns for tools
- **Troubleshooting**: Common issues and their solutions
- **Architecture decisions**: Why things are structured a certain way

### Documentation Review Cycle

- **On addition**: New docs should be reviewed by docs-maintainer agent
- **On significant changes**: Major updates trigger review
- **Periodic audit**: Quarterly review of all documentation for accuracy

---

## Quick Reference

| Topic | Document | Location |
|-------|----------|----------|
| Docker/Containers | global-instructions.md | `/docs/global-instructions.md` |
| Security Policies | global-instructions.md | `/docs/global-instructions.md` |
| Development Tools | global-instructions.md | `/docs/global-instructions.md` |
| Best Practices | best-practices.md | `/docs/best-practices.md` |
| Permissions Guide | permissions-guide.md | `/docs/permissions-guide.md` |
| NixOS Configuration | nixos-config-expert.md | `/agents/nixos-config-expert.md` |
| Version Control (jj) | source-control-expert.md | `/agents/source-control-expert.md` |
| Code Review | code-reviewer.md | `/agents/code-reviewer.md` |
| Documentation Maintenance | docs-maintainer.md | `/agents/docs-maintainer.md` |
| Hooks System | README.md | `/hooks/README.md` |
| Forced Eval Hook | forced-eval-skill.md | `/hooks/forced-eval-skill.md` |
| Custom Commands | README.md | `/commands/README.md` |
| MCP Servers | README.md | `/mcp-servers/README.md` |
| Plugin Config | marketplace.json | `/.claude-plugin/marketplace.json` |

---

## Meta

**Last Updated**: 2025-11-18
**Maintained By**: docs-maintainer agent
**Purpose**: Serve as the single source of truth for documentation navigation

**Note**: This charter should be the first place you look when trying to understand the documentation structure. Keep it updated!
