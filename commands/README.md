# Claude Code Slash Commands

This directory contains custom slash commands for Claude Code. Slash commands let you create reusable prompts that can be invoked with `/command-name`.

## Available Commands

### /jj-describe-all
Automatically describes all jj commits from trunk onwards using conventional commit format.

**Usage**: Simply type `/jj-describe-all` in Claude Code

**What it does**:
1. Lists all commits from trunk to current with `jj log`
2. For each commit without a description:
   - Shows the diff
   - Creates a conventional commit message
   - Applies the description

## How to Create a Slash Command

1. **Create a markdown file** with your prompt:
```markdown
Your command instructions here.

Be clear about what Claude should do when this command is invoked.
```

2. **Name the file** appropriately:
   - Filename becomes the command name
   - Use kebab-case: `my-command.md` → `/my-command`

3. **Deploy the command**:
```bash
# Copy to Claude config
cp my-command.md ~/.claude/commands/

# Or use the installation script
../scripts/install.sh
```

4. **Use the command** by typing `/my-command` in Claude Code

## Command Best Practices

- **Be specific** - Clear instructions get better results
- **Include context** - Explain any assumptions or requirements
- **Use examples** - Show expected format/output when relevant
- **Keep it focused** - One clear task per command
- **Document parameters** - If your command expects specific inputs

## Examples of Good Commands

### Simple Task Commands
```markdown
Run all tests and fix any failures. Start by running the test suite,
analyze any failures, and make the necessary code changes to fix them.
```

### Workflow Commands
```markdown
Prepare a release:
1. Run all tests
2. Update version number in package.json
3. Update CHANGELOG.md with recent commits
4. Create git tag
5. Build release artifacts
```

### Analysis Commands
```markdown
Analyze the codebase for security vulnerabilities:
- Check for hardcoded secrets
- Look for SQL injection risks
- Identify unsafe file operations
- Report findings with file locations
```

## File Format

- Must be markdown files (`.md`)
- Filename (without .md) becomes the command name
- Can include code blocks, lists, and formatting
- No frontmatter required (unlike agents)

## Deployment

Commands are deployed to `~/.claude/commands/` where Claude Code will discover them automatically.

## Tips

- Commands are great for repetitive workflows
- Can reference other tools and agents in commands
- Works well with project-specific CLAUDE.md files
- Consider creating project-specific command directories
