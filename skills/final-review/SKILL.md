---
name: final-review
description: Use when finishing a task that changed code, config, scripts, prompts, or documentation. Runs the final build/test/lint/review loop, fixes reasonable issues, and reports remaining findings or skipped checks before the final answer.
---

# Final Review

**Announce at start**: "I'm using the final-review skill to validate and review the finished changes before the final answer."

Use this skill near the end of a task, after implementation is complete and before the final answer.

## Preferred Reviewer

Use the opposing agent when available:

- If you are running in Codex, prefer `claude -p` for the external review.
- If you are running in Claude, prefer `codex review --uncommitted`.

Use the helper script when available:

```bash
skills/final-review/scripts/opposing-review.sh from-codex
skills/final-review/scripts/opposing-review.sh from-claude
```

If the opposing CLI is unavailable or fails, fall back to doing the review directly in the current agent.

## When To Skip

Skip the skill only when at least one of these is true:

- The user explicitly says to skip review.
- No material files changed.
- The task was purely conversational and did not touch the workspace.

If you skip, say why in one sentence.

## Workflow

### 1. Confirm the review scope

Check what changed. Prefer `jj diff --stat` or `jj diff`. If the repo is not using jj, use the local diff tooling that already exists in the workspace.

Review only material changes. Ignore generated files, vendored code, and unrelated user changes.

### 2. Run the validation loop

Find the smallest relevant validation commands from the repo itself:

- project instructions such as `AGENTS.md`, `CLAUDE.md`, or equivalent
- package manager scripts
- existing test, lint, or build commands already used by the project

Run what is relevant to the files you changed:

- build
- tests
- lint or static analysis

If a check cannot run, do not invent one. Report the skipped check and the reason.

### 3. Perform the review

Review the changed files adversarially:

- bugs and behavioral regressions
- security issues
- missing or weak tests
- bad assumptions
- unnecessary complexity
- mismatch with repo instructions

Findings come first. Use file and line references when possible.

Prefer an opposing-agent review first:

- Claude session: use `codex review --uncommitted` when available.
- Codex session: use `claude -p` with a strict review prompt when available.

Then sanity-check the findings yourself before presenting them.

If the environment does not support an opposing-agent review, do the review directly.

### 4. Fix what is reasonable

If the review finds issues that are clearly in scope and cheap to fix, fix them now and rerun the affected checks.

Do not start unrelated refactors. Do not silently leave a failing check unfixed if it was introduced by your change.

### 5. Final response requirements

Before sending the final answer, include:

- what validation commands ran
- what was skipped
- whether review found issues
- any remaining risks or follow-up items

Never say the work is done if you skipped validation or review without saying so.

## Success Criteria

The skill succeeded when:

1. The changed files were reviewed deliberately, not just tested.
2. Relevant build/test/lint checks were run or explicitly skipped with a reason.
3. Any findings were either fixed or surfaced clearly in the final answer.
