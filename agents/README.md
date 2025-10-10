# Claude Code Custom Agents

This directory contains custom agent definitions for Claude Code. Agents are specialized sub-agents with specific expertise and behaviors.

## Available Agents

### nixos-config-expert
- **Model**: Opus
- **Expertise**: NixOS, Home Manager, Nix flakes
- **Use When**: Adding packages, modifying system configs, working with Nix
- **Key Features**:
  - Always uses flakes
  - Prioritizes reproducibility
  - Validates configurations before completion
  - Follows user's established patterns

### source-control-expert
- **Model**: Sonnet
- **Expertise**: Jujutsu (jj), container registries, Git workflows
- **Use When**: Tagging/pushing Docker images, managing commits
- **Key Features**:
  - Works with already-built images
  - Uses jj for version control
  - Handles Gitea container registry operations
  - Creates conventional commit messages

## How to Create a Custom Agent

1. **Create a new markdown file** with frontmatter:
```markdown
---
name: agent-name
description: When to use this agent and what it does
model: sonnet | opus | haiku
color: blue | green | red | purple | yellow | orange
---

Your agent instructions here...
```

2. **Write clear instructions** that include:
- Core principles
- Technical standards
- Workflow steps
- Quality assurance requirements
- What NOT to do

3. **Deploy the agent**:
```bash
# Copy to Claude config
cp agent-name.md ~/.claude/agents/

# Or use the installation script
../scripts/install.sh
```

4. **Test the agent** by invoking it with appropriate tasks

## Agent Best Practices

- **Be specific** about when the agent should be used
- **Set clear boundaries** (what it should/shouldn't do)
- **Include examples** in the description frontmatter
- **Define quality standards** for the agent's output
- **Choose the right model** for the task (Opus for complex, Sonnet for balanced)

## File Format

All agent files must:
- Be valid markdown
- Have YAML frontmatter with required fields
- Use `.md` extension
- Have clear, actionable instructions

## Deployment

Agents are deployed to `~/.claude/agents/` where Claude Code will automatically discover them.
