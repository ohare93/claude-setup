# Claude Code Setup Repository

A centralized collection of custom configurations, agents, commands, templates, and documentation for working with [Claude Code](https://claude.com/code).

## What's Included

### 📊 Status Line Enhancement

- **contextbricks** - Real-time context tracking with brick visualization showing token breakdown, git status, model info, and session metrics

### 🤖 Custom Agents (`agents/`)

Specialized sub-agents with specific expertise:

- **nixos-config-expert** (Opus) - NixOS, Home Manager, and Nix flakes expert
- **source-control-expert** (Sonnet) - Jujutsu (jj), container registries, and version control

[Learn more about agents →](agents/README.md)

### ⚡ Slash Commands (`commands/`)

Reusable prompts for common workflows:

- **/jj-describe-all** - Auto-describe all jj commits with conventional format

[Learn more about commands →](commands/README.md)

### 📝 Templates (`templates/`)

Starter templates for project documentation:

- **CLAUDE-project.md.template** - General software projects
- **CLAUDE-docker.md.template** - Docker/containerized services
- **settings.local.json.template** - Project-specific permissions

[Learn more about templates →](templates/README.md)

### 🔌 MCP Servers (`mcp-servers/`)

Catalog of Model Context Protocol servers:

- **mcp-ssh-unraid** - 86 tools for Unraid server management
- **mcp-filemanager** - Privacy-preserving file operations
- **serena** - Semantic code analysis via language servers (runs via Nix)

[Learn more about MCP servers →](mcp-servers/README.md)

### 📚 Documentation (`docs/`)

Comprehensive guides and learnings:

- **global-instructions.md** - Universal coding preferences
- **best-practices.md** - Hard-won knowledge from real issues
- **permissions-guide.md** - How to configure Claude Code permissions

## Quick Start

### Installation

**Step 1: Install via Plugin Marketplace**

In Claude Code, run the `/plugin` command and enter the repository path:

```
/plugin
> /home/jmo/Development/claude-setup
```

This installs all agents, commands, and templates automatically.

**Step 2: Install Dependencies (includes contextbricks status line)**

Navigate to the repository and install npm dependencies:

```bash
cd ~/Development/claude-setup
npm install
```

This will automatically install and configure:
- **contextbricks** - Real-time context tracking with brick visualization for your status line

**Step 3: Symlink Global Instructions**

Link the global instructions to your Claude Code config:

```bash
ln -sf ~/Development/claude-setup/docs/global-instructions.md ~/.claude/CLAUDE.md
```

Your existing `~/.claude/CLAUDE.md` will be backed up to `~/.claude/CLAUDE.md.backup`.

**Step 4: Restart Claude Code**

Restart Claude Code to load all components.

### Creating a New Project

1. **Copy appropriate templates** for your language (see `templates/LANGUAGE-GUIDE.md`):

```bash
# For Rust projects
cp templates/CLAUDE-project.md.template ~/Development/my-app/CLAUDE.md
cp templates/settings-rust.json.template ~/Development/my-app/.claude/settings.local.json

# For Python projects
cp templates/CLAUDE-project.md.template ~/Development/my-app/CLAUDE.md
cp templates/settings-python.json.template ~/Development/my-app/.claude/settings.local.json

# See LANGUAGE-GUIDE.md for other languages
```

2. **Customize** the templates with project-specific details

### Updating

All updates happen automatically:

- **Agents/Commands**: Managed by plugin marketplace, auto-update
- **Global Instructions**: Symlinked, edit `docs/global-instructions.md` directly
- **Templates**: Copy fresh templates when starting new projects

## Repository Structure

```
claude-setup/
├── .claude-plugin/      # Plugin marketplace metadata
│   └── marketplace.json
├── agents/              # Custom Claude Code agents
│   ├── nixos-config-expert.md
│   ├── source-control-expert.md
│   └── README.md
├── commands/            # Slash commands
│   ├── jj-describe-all.md
│   └── README.md
├── templates/           # CLAUDE.md and config templates
│   ├── CLAUDE-project.md.template
│   ├── settings.local.json.template
│   ├── settings-*.json.template  # Language-specific permissions
│   ├── LANGUAGE-GUIDE.md
│   └── README.md
├── mcp-servers/         # MCP server documentation
│   └── README.md
├── docs/                # Comprehensive documentation
│   ├── global-instructions.md  # Symlinked to ~/.claude/CLAUDE.md
│   ├── best-practices.md
│   └── permissions-guide.md
└── README.md            # This file
```

## Usage Examples

### Using Custom Agents

Claude Code automatically invokes agents when appropriate, or you can request them:

```
You: "Add firefox to my NixOS configuration"
Claude: *invokes nixos-config-expert agent*
```

```
You: "Tag and push the Docker image to my registry"
Claude: *invokes source-control-expert agent*
```

### Using Slash Commands

Type the command in Claude Code:

```
/jj-describe-all
```

Claude will execute the command's instructions.

### Using Templates

Start a new project with best practices baked in:

```bash
# For a software project
cp templates/CLAUDE-project.md.template ~/Development/my-app/CLAUDE.md

# For a Docker service
cp templates/CLAUDE-docker.md.template ~/Development/my-service/CLAUDE.md

# Edit and customize
vim ~/Development/my-app/CLAUDE.md
```

## Key Features

### 🎯 Specialized Agents

Agents bring deep expertise to specific domains:
- Use Opus for complex reasoning (NixOS configurations)
- Use Sonnet for balanced tasks (version control)
- Clear boundaries on what each agent does/doesn't do

### ⚡ Workflow Automation

Slash commands encapsulate common workflows:
- No need to remember complex command sequences
- Consistent results every time
- Easy to share across team

### 📋 Best Practices Built-In

Templates codify lessons learned:
- Docker volume optimization for Unraid
- Traefik middleware ordering
- NixOS external file inclusion patterns
- Kanata keyboard configuration gotchas

### 🔒 Security Conscious

Permissions guide helps you balance convenience with security:
- Pre-approve safe operations
- Require confirmation for risky ones
- Project-specific vs global permissions

## When to Use Each Component

### Use Agents When:
- You need specialized expertise (NixOS, container registries)
- The task requires specific quality standards
- You want consistent behavior across similar tasks

### Use Slash Commands When:
- You repeat the same workflow frequently
- You want to standardize a process
- You need quick access to complex instructions

### Use Templates When:
- Starting a new project
- Onboarding to an existing project
- Standardizing documentation across projects

### Use MCP Servers When:
- You need tools beyond Claude Code's built-ins
- You're working with specific infrastructure (Unraid)
- You want read-only debugging access to remote systems

## Customization

### Creating New Agents

1. Create a new `.md` file in `agents/`
2. Add frontmatter (name, description, model, color)
3. Write clear instructions and boundaries
4. Test with representative tasks
5. Plugin marketplace auto-updates on restart

[Full guide →](agents/README.md)

### Creating New Commands

1. Create a markdown file in `commands/`
2. Write clear, actionable instructions
3. Test by invoking in Claude Code
4. Plugin marketplace auto-updates on restart

[Full guide →](commands/README.md)

### Extending Templates

Templates are starting points - customize them:
- Add project-specific sections
- Remove irrelevant parts
- Include your team's conventions
- Document common gotchas

## Best Practices

### Keep It Updated

- Add learnings to `docs/best-practices.md` as you discover them
- Update templates when you find better patterns
- Edit agents/commands directly in repo - changes auto-sync via plugin system

### Version Control Everything

- This repo should be in version control (jj/git)
- Track changes to understand what works
- Revert when experiments don't pan out
- Commit improvements to agents, docs, and templates

### Document the "Why"

Don't just document commands - explain:
- Why this approach over alternatives
- What problems it solves
- When NOT to use it

### Start Minimal, Grow Organically

- Don't create agents/commands preemptively
- Notice when you repeat something 3+ times
- Then codify it as an agent/command

## Troubleshooting

### Plugin Installation Issues

1. Ensure you're running latest Claude Code version
2. Verify `.claude-plugin/marketplace.json` exists in repo
3. Try removing and re-adding the plugin via `/plugin`
4. Check Claude Code logs for errors

### Agents Not Appearing

1. Verify plugin is installed via `/plugin`
2. Check file format (markdown with frontmatter)
3. Restart Claude Code
4. Update `marketplace.json` if you added new agents

### Commands Not Working

1. Verify plugin is installed via `/plugin`
2. Check filename matches command name
3. Restart Claude Code
4. Try without the leading `/`

### Global Instructions Not Loading

1. Verify symlink: `ls -la ~/.claude/CLAUDE.md`
2. Should point to `~/Development/claude-setup/docs/global-instructions.md`
3. Recreate symlink if broken:
   ```bash
   ln -sf ~/Development/claude-setup/docs/global-instructions.md ~/.claude/CLAUDE.md
   ```

### Permissions Issues

1. Review `docs/permissions-guide.md`
2. Check `~/.claude/settings.json` for global permissions
3. Check `.claude/settings.local.json` for project permissions
4. Use deny rules to override allows if needed

## Contributing

This is a personal setup repository, but you can:

1. Fork for your own setup
2. Use as inspiration for your configs
3. Share interesting agents/commands
4. Suggest improvements via issues/PRs

## Related Resources

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [MCP Specification](https://github.com/anthropics/model-context-protocol)
- [Example MCP Servers](https://github.com/modelcontextprotocol/servers)

## License

MIT - Use freely for your own Claude Code setup

## Acknowledgments

Built with insights from:
- Countless debugging sessions
- Trial and error with NixOS configurations
- Working with Docker/Traefik/Authelia
- Learning Hyprland and Kanata gotchas
- Exploring jj version control workflows

Every entry in `docs/best-practices.md` represents time saved for future-me (and maybe you!).
