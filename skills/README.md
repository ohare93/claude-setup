# Skills

Skills are interactive multi-step workflows that guide Claude through complex processes. Unlike simple slash commands, skills can ask questions, make decisions, and adapt based on context.

## What Are Skills?

Skills are structured workflows defined in markdown files that Claude follows to accomplish complex tasks. They're most valuable for:

- **Interactive processes** - Workflows that require user input and decisions
- **Multi-step tasks** - Complex operations broken into phases
- **Intelligent automation** - Tasks requiring AI understanding (like conflict resolution)
- **Guided execution** - Processes that benefit from structured validation

## Available Skills

### consolidate-branches

Consolidate multiple PR branches onto a target branch using jj multi-parent rebase with intelligent AI-powered conflict resolution.

**When to use**:
- You have multiple feature branches from different Claude sessions
- Branches likely have conflicts that need intelligent merging
- You want to combine multiple PRs into one consolidated change

**What it does**:
1. Discovers branches needing consolidation
2. Lets you select which branches to merge
3. Analyzes the intent behind each branch
4. Performs multi-parent rebase
5. Intelligently resolves conflicts by understanding code intent
6. Verifies all changes are present
7. Leaves workspace ready for review

**Example usage**:
```
You: "I have 3 PR branches that need to be merged onto main"
Claude: *invokes consolidate-branches skill*
```

## How Skills Work

When Claude invokes a skill:

1. **Skill loads** - The SKILL.md file is read and provides instructions
2. **Claude follows the workflow** - Step by step as defined in the skill
3. **Interactive decisions** - Claude asks questions using AskUserQuestion
4. **Adaptive execution** - Adjusts based on context and user responses
5. **Validation** - Presents results for confirmation

Skills are more dynamic than slash commands - they can loop, make decisions, and handle unexpected situations.

## Creating Your Own Skills

### File Structure

```
skills/
└── your-skill-name/
    └── SKILL.md
```

### Skill Template

```markdown
---
name: your-skill-name
description: Brief description of what this skill does
---

# Your Skill Name

**Announce at start**: "I'm using the your-skill-name skill to [what you're doing]."

## Overview

Clear description of what this skill accomplishes and when to use it.

## Workflow

### Phase 1: First Step

Detailed instructions for Claude to follow...

### Phase 2: Next Step

More instructions...

## Error Handling

How to handle common errors...

## Key Principles

Important guidelines Claude should follow...

## Success Criteria

How to know if the skill succeeded...
```

### Best Practices

**Clear Instructions**
- Write step-by-step instructions Claude can follow
- Be explicit about tools to use (Bash, Read, Edit, etc.)
- Include exact commands when applicable

**Interactive Elements**
- Use AskUserQuestion for decisions and validations
- Present options with clear trade-offs
- Ask for confirmation at key milestones

**Error Handling**
- Anticipate common failure modes
- Provide recovery strategies
- Give Claude guidance on when to abort

**Validation**
- Include verification steps
- Check that goals were achieved
- Present results to user for confirmation

**Structure**
- Break complex tasks into phases
- Use clear headings and organization
- Include examples and code snippets

### Testing Your Skill

1. Create the skill file in `skills/your-skill-name/SKILL.md`
2. Add it to `.claude-plugin/marketplace.json` in the `skills` array
3. Restart Claude Code to load the skill
4. Test by asking Claude to perform the task the skill handles
5. Iterate based on what works/doesn't work

Consider using the `superpowers:testing-skills-with-subagents` skill to systematically test your skill under various conditions.

## Skills vs Commands vs Agents

### Use Skills When:
- Interactive multi-step workflows needed
- Decisions required along the way
- AI intelligence adds value (understanding intent)
- Process benefits from guided execution

### Use Commands When:
- Simple, linear workflows
- No decisions needed
- Fire-and-forget execution
- Quick access to instructions

### Use Agents When:
- Specialized expertise required
- Specific quality standards needed
- Entire conversation context helpful
- Autonomous execution preferred

## Skill Development Tips

**Start Simple**
- Begin with core workflow
- Add complexity incrementally
- Test each addition

**Think Phases**
- Break task into logical phases
- Each phase should have clear input/output
- Phases should be independently testable

**User Control**
- Ask before making big changes
- Present options rather than assuming
- Leave final decisions to user

**Document Why**
- Explain the reasoning behind steps
- Note trade-offs in approach
- Include success criteria

**Handle Failures Gracefully**
- Don't assume success
- Check results after each phase
- Provide clear error messages

## Updating Skills

Skills in the plugin are automatically updated when:
1. You edit the SKILL.md file in the repository
2. You restart Claude Code

No need to reinstall the plugin - changes sync automatically via the plugin marketplace system.

## Examples from Other Plugins

The superpowers plugin includes many excellent skills you can learn from:

- **brainstorming** - Interactive design refinement using Socratic method
- **test-driven-development** - Write tests first, then implementation
- **systematic-debugging** - Four-phase debugging framework
- **using-git-worktrees** - Set up isolated git worktrees

Study these to see different approaches to skill design.

## Troubleshooting

**Skill Not Appearing**
1. Verify file is in `skills/your-skill-name/SKILL.md`
2. Check `.claude-plugin/marketplace.json` includes the skill
3. Restart Claude Code
4. Check for syntax errors in frontmatter

**Claude Not Following Skill**
1. Ensure instructions are clear and specific
2. Check for ambiguous language
3. Add more explicit tool usage examples
4. Test with simpler examples first

**Skill Seems Too Complex**
1. Break into smaller phases
2. Add more intermediate validations
3. Provide clearer examples
4. Consider if it should be multiple skills

## Contributing Skills

Skills that prove valuable can be:
1. Shared with others via your plugin
2. Contributed to the superpowers plugin
3. Published as standalone plugins
4. Used as examples for the community

Good skills solve real problems you've encountered multiple times and codify the best way to handle them.
