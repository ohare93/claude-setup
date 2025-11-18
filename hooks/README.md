# Claude Code Hooks

Hooks allow you to inject custom instructions at specific points in Claude Code's workflow. This directory contains hooks that improve Claude Code's behavior, particularly for skill activation reliability.

## What Are Hooks?

Hooks are markdown files containing instructions that execute automatically at specific trigger points:

- **user-prompt-submit** - Runs every time you submit a prompt to Claude
- **tool-call** - Runs before specific tool executions
- **session-start** - Runs when a new session begins

## Available Hooks

### Forced Eval Skill Hook

**File**: `forced-eval-skill.md`
**Type**: User Prompt Submit Hook
**Purpose**: Dramatically improves skill activation reliability
**Success Rate**: 84% (vs ~50% baseline)

This hook forces Claude to explicitly evaluate each available skill before starting any implementation work, creating a commitment mechanism that prevents skills from being overlooked.

**When to use:**
- You have custom skills that aren't activating reliably
- You want consistent skill usage across sessions
- You're frustrated by Claude ignoring relevant skills

**When NOT to use:**
- You don't have any custom skills installed
- You prefer Claude to decide autonomously without forced evaluation
- You find the explicit evaluation output too verbose

## Installation

### Method 1: Global Installation (Recommended)

Install hooks globally so they apply to all Claude Code sessions:

```bash
# Create hooks directory if it doesn't exist
mkdir -p ~/.claude/hooks

# Copy the forced eval hook
cp hooks/forced-eval-skill.md ~/.claude/hooks/user-prompt-submit.md
```

This installs the forced eval hook as your user-prompt-submit hook, so it runs on every prompt.

### Method 2: Project-Specific Installation

Install hooks for a specific project only:

```bash
# In your project directory
mkdir -p .claude/hooks

# Copy the forced eval hook
cp ~/Development/claude-setup/hooks/forced-eval-skill.md .claude/hooks/user-prompt-submit.md
```

### Method 3: Symlink (For Easy Updates)

Symlink to always use the latest version:

```bash
# Global (recommended)
mkdir -p ~/.claude/hooks
ln -sf ~/Development/claude-setup/hooks/forced-eval-skill.md ~/.claude/hooks/user-prompt-submit.md

# Or project-specific
mkdir -p .claude/hooks
ln -sf ~/Development/claude-setup/hooks/forced-eval-skill.md .claude/hooks/user-prompt-submit.md
```

## Hook Naming Convention

Hooks must be named according to their trigger point:

- `user-prompt-submit.md` - Triggers on every user prompt
- `tool-call-<tool-name>.md` - Triggers before specific tool calls
- `session-start.md` - Triggers at session start

## How the Forced Eval Hook Works

The forced eval hook implements a three-step protocol:

1. **EVALUATE** - Claude must explicitly check each skill and state YES/NO with reasoning
2. **ACTIVATE** - Any skills marked YES must be activated immediately using `Skill(skill-name)`
3. **IMPLEMENT** - Only after evaluation and activation can implementation begin

The hook uses strong language (MANDATORY, CRITICAL, WORTHLESS) to create psychological commitment and prevent Claude from skipping the evaluation.

## Testing Results

Based on 200+ tests by Scott Spence:

| Approach | Success Rate | Notes |
|----------|--------------|-------|
| Baseline | ~50% | Standard skill descriptions alone |
| Forced Eval Hook | 84% | Consistent, no external dependencies |
| LLM Eval Hook | 80% | 10% cheaper but can fail spectacularly |

## Troubleshooting

### Hook Not Running

1. Verify file location: `ls -la ~/.claude/hooks/user-prompt-submit.md`
2. Check file name matches trigger point exactly
3. Ensure file is valid markdown
4. Restart Claude Code session
5. Check Claude Code settings for hook configuration

### Too Verbose Output

The forced eval hook produces explicit output for each skill evaluation. This is intentional and necessary for the high success rate. If you find it too verbose:

- Accept the verbosity as the cost of reliability
- Or remove the hook and accept lower skill activation rates
- Or customize the hook to reduce output (but test that it still works)

### Skills Still Not Activating

1. Verify skills are properly installed: check plugin marketplace
2. Ensure skill descriptions are clear and specific
3. Check that skills are actually relevant to the task
4. Consider that some failures are expected (84% is not 100%)

## Customization

You can customize the forced eval hook by editing `forced-eval-skill.md`:

- Adjust the language strength
- Modify the evaluation format
- Add project-specific evaluation criteria
- Change the activation requirements

**Warning**: Changes may affect the success rate. Test thoroughly if you customize.

## Advanced: Creating Custom Hooks

To create your own hooks:

1. Create a markdown file with clear instructions
2. Name it according to the trigger point
3. Test with representative scenarios
4. Document what it does and when to use it
5. Share in this directory if useful for others

Example custom hook structure:

```markdown
# My Custom Hook

**Purpose**: [What this hook does]
**Type**: [user-prompt-submit / tool-call / session-start]

---

[Instructions that Claude will follow when the hook triggers]

---

## Notes

[Additional context, usage notes, etc.]
```

## Resources

- [Scott Spence's Testing Methodology](https://scottspence.com/posts/how-to-make-claude-code-skills-activate-reliably)
- [Claude Code Hooks Documentation](https://docs.claude.com/en/docs/claude-code)
- [Original Research Discussion](https://news.ycombinator.com/item?id=45950114)

## Best Practices

1. **Start with the forced eval hook** - It has the best tested results
2. **Use symlinks for easy updates** - So you always have the latest version
3. **Test after installation** - Verify the hook is running with a simple prompt
4. **Monitor success rate** - Note if skills activate more reliably
5. **Keep hooks focused** - One clear purpose per hook
6. **Document customizations** - If you modify hooks, note what and why

## When NOT to Use Hooks

Don't use the forced eval hook if:

- You have no custom skills installed (nothing to evaluate)
- You want minimal output verbosity
- You prefer Claude's autonomous decision-making
- Your skills already activate reliably without intervention

## Contributing

Found a useful hook? Add it to this directory:

1. Create the hook markdown file
2. Document it in this README
3. Include testing results if available
4. Commit and push to the repository

Every hook in this directory should have:
- Clear purpose statement
- Installation instructions
- Known success rates or limitations
- When to use / not use guidance
