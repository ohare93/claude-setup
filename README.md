# Claude Code Setup Repository

A centralized collection of custom configurations, agents, commands, templates, and documentation for working with [Claude Code](https://claude.com/code).

## What's Included

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

[Learn more about MCP servers →](mcp-servers/README.md)

### 📚 Documentation (`docs/`)

Comprehensive guides and learnings:

- **global-instructions.md** - Universal coding preferences
- **best-practices.md** - Hard-won knowledge from real issues
- **permissions-guide.md** - How to configure Claude Code permissions

## Quick Start

### Installation

Deploy to your Claude Code configuration:

```bash
cd ~/Development/claude-setup
./scripts/install.sh
```

This copies:
- Agents to `~/.claude/agents/`
- Commands to `~/.claude/commands/`

Restart Claude Code to load the new components.

### Creating a New Project

1. **Copy a template** to your project:
```bash
cp templates/CLAUDE-project.md.template ~/Development/my-project/CLAUDE.md
```

2. **Customize** the template with project-specific details

3. **Optional**: Add project-specific permissions:
```bash
cp templates/settings.local.json.template ~/Development/my-project/.claude/settings.local.json
```

### Syncing Changes

After modifying agents or commands in `~/.claude/`, sync back to repo:

```bash
./scripts/sync.sh
jj describe -m "sync: update from ~/.claude/"
jj git push
```

## Repository Structure

```
claude-setup/
├── agents/              # Custom Claude Code agents
│   ├── nixos-config-expert.md
│   ├── source-control-expert.md
│   └── README.md
├── commands/            # Slash commands
│   ├── jj-describe-all.md
│   └── README.md
├── templates/           # CLAUDE.md and config templates
│   ├── CLAUDE-project.md.template
│   ├── CLAUDE-docker.md.template
│   ├── settings.local.json.template
│   └── README.md
├── mcp-servers/         # MCP server documentation
│   └── README.md
├── docs/                # Comprehensive documentation
│   ├── global-instructions.md
│   ├── best-practices.md
│   └── permissions-guide.md
├── scripts/             # Utility scripts
│   ├── install.sh       # Deploy to ~/.claude/
│   └── sync.sh          # Sync from ~/.claude/
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

1. Copy an existing agent as starting point
2. Modify the frontmatter (name, description, model, color)
3. Write clear instructions and boundaries
4. Test with representative tasks
5. Deploy with `./scripts/install.sh`

[Full guide →](agents/README.md)

### Creating New Commands

1. Create a markdown file in `commands/`
2. Write clear, actionable instructions
3. Test by invoking in Claude Code
4. Deploy with `./scripts/install.sh`

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
- Sync changes back with `./scripts/sync.sh`

### Version Control Everything

- This repo should be in version control (jj/git)
- Track changes to understand what works
- Revert when experiments don't pan out

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

### Agents Not Appearing

1. Check files are in `~/.claude/agents/`
2. Verify file format (markdown with frontmatter)
3. Restart Claude Code
4. Check Claude Code logs

### Commands Not Working

1. Verify file in `~/.claude/commands/`
2. Check filename matches command name
3. Restart Claude Code
4. Try without the leading `/`

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
