# Final Review Skill Setup

This repository now includes a shared `final-review` skill for end-of-task validation and code review.

## What It Solves

- You do not need to remember a manual review command at the end.
- Claude Code can be nudged into running the skill automatically through a prompt hook.
- Codex can be nudged into running the same skill through `AGENTS.md` instructions.
- The actual review can be delegated to the opposing agent instead of being purely self-review.

## Claude Code Setup

Install the combined prompt hook as your `user-prompt-submit` hook:

```bash
mkdir -p ~/.claude/hooks
ln -sf ~/Development/active/agentic/claude-setup/hooks-docs/forced-eval-with-final-review.md ~/.claude/hooks/user-prompt-submit.md
```

This hook:

- forces skill evaluation at the start of each prompt
- defers `final-review` until the end of implementation
- requires `final-review` before the final answer when material files changed

When `final-review` runs inside Claude, it should prefer `codex review --uncommitted` if the `codex` CLI is available.

## Codex Setup

Codex does not have the same hook model in this repository, so the practical equivalent is an `AGENTS.md` rule.

Add this to the repo-level `AGENTS.md` you want Codex to follow:

```md
## Final Review

- If you make material code, config, script, prompt, or documentation changes, use the `final-review` skill before the final answer unless I explicitly say to skip review.
- Treat `final-review` as part of the completion gate, not as an optional extra.
- When possible, have `final-review` run the review in Claude via `skills/final-review/scripts/opposing-review.sh from-codex` instead of reviewing only with Codex itself.
- Final responses must mention which validation commands ran, what was skipped, and any remaining findings or risks.
```

## Installing The Skill In Both Agents

Claude Code loads this skill from the plugin marketplace entry in this repository.

For Codex, install or symlink the same skill directory into your Codex skills directory so the skill can be discovered there as well. The source of truth is:

- `skills/final-review/SKILL.md`
- `skills/final-review/scripts/opposing-review.sh`

If you keep a personal skills repo for Codex, copy or symlink that folder there.

## Suggested Usage Pattern

Use the hook or `AGENTS.md` rule to trigger the skill automatically, but keep the skill itself focused on one job:

1. detect changed files
2. run build/test/lint when relevant
3. review the diff adversarially, preferably in the opposing agent
4. fix cheap issues
5. report the remaining risks honestly
