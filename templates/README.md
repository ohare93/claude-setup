# CLAUDE.md Templates

This directory contains templates for creating project-specific CLAUDE.md files. These files provide context and instructions to Claude Code when working in your projects.

## Available Templates

### CLAUDE-project.md.template
General-purpose template for software projects. Includes sections for:
- Project overview and tech stack
- Development commands
- Project structure
- Common tasks and debugging
- Dependencies and design principles
- Testing and deployment

**Best For**: Most software development projects (web apps, libraries, tools)

### CLAUDE-docker.md.template
Specialized template for Docker/container-based services. Includes:
- Docker configuration (volumes, networks, env vars)
- Traefik and Authelia setup
- Unraid-specific optimizations
- Debugging with MCP tools
- Common container issues

**Best For**: Dockerized services, especially those deployed to Unraid

### settings.local.json.template
Template for project-specific Claude Code permissions. Includes common safe permissions:
- Web fetching from common domains
- Basic bash commands (mkdir, ls, cat, grep)
- jj version control operations
- Read access to Development directory

**Best For**: Projects that need specific permissions beyond global defaults

## How to Use Templates

1. **Copy the template** to your project:
```bash
cp templates/CLAUDE-project.md.template ~/Development/my-project/CLAUDE.md
```

2. **Customize** the template:
   - Fill in project-specific details
   - Remove irrelevant sections
   - Add project-specific gotchas
   - Document any special workflows

3. **Keep it updated** as your project evolves:
   - Add new learnings
   - Document common issues
   - Update commands as they change

## What Makes a Good CLAUDE.md

### Do Include
- **Project overview** - What it does and why
- **Tech stack** - Languages, frameworks, key tools
- **Common commands** - How to build, test, run
- **Project structure** - Directory organization
- **Common issues** - Known gotchas with solutions
- **Design principles** - Important patterns to follow

### Don't Include
- Implementation details that change frequently
- Obvious information Claude would already know
- Credentials or secrets (use environment variables)
- Too much detail (Claude can explore the code)

## Template Customization Examples

### For a Python Project
```markdown
## Tech Stack
- **Language**: Python 3.11+
- **Framework**: FastAPI
- **Key Dependencies**: pydantic, sqlalchemy, alembic

## Development Commands
### Setup
```bash
python -m venv venv
source venv/bin/activate
pip install -e ".[dev]"
```
```

### For a Monorepo
```markdown
## Project Structure
```
project/
├── packages/
│   ├── frontend/    # React SPA
│   ├── backend/     # Node.js API
│   └── shared/      # Shared types
└── apps/
    └── mobile/      # React Native
```

## Building
Build specific package:
```bash
npm run build --workspace=@project/frontend
```
```

## Best Practices

1. **Start from a template** - Don't write from scratch
2. **Be concise** - Claude can explore details, provide the important context
3. **Update regularly** - Add learnings as you discover them
4. **Use examples** - Show don't tell for complex workflows
5. **Document gotchas** - If you spent time figuring it out, document it

## Related Files

These templates work well with:
- **agents/** - Custom specialized agents
- **commands/** - Reusable slash commands
- **docs/global-instructions.md** - Your universal coding preferences

## Deployment

Place CLAUDE.md in your project root. Claude Code automatically reads it when working in that directory.

For settings.local.json, place in `.claude/settings.local.json` within your project.
