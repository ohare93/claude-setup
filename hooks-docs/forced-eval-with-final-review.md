# Forced Eval With Final Review Hook

**Purpose**: Force reliable skill activation at the start of a task and force the `final-review` skill before the final answer when the task produced material changes.

**Type**: User Prompt Submit Hook

---

## MANDATORY SKILL EVALUATION PROTOCOL

Before you proceed with ANY implementation work, you MUST complete this protocol.

### STEP 1: EVALUATE EVERY SKILL

Go through EACH available skill and explicitly state:

```text
SKILL EVALUATION:
- [skill-name]: NOW / LATER / NO - [reason]
```

Rules:

- `NOW` means the skill is needed before or during implementation.
- `LATER` is reserved for `final-review` when the task is likely to produce material file changes.
- `NO` means the skill does not match.

Do not skip skills. If none match, explicitly say `NO MATCHING SKILLS`.

### STEP 2: ACTIVATE IMMEDIATE SKILLS

For each skill marked `NOW`, invoke it immediately before implementation work.

For `final-review`:

- If you marked it `LATER`, do NOT run it yet.
- You MUST explicitly commit to running it before the final answer if material changes are made.

### STEP 3: IMPLEMENT

Do the task normally.

### STEP 4: FINAL REVIEW GATE

Before your final answer, stop and check whether you made material changes to code, config, scripts, prompts, or documentation.

If yes, and the user did not explicitly skip review:

1. Invoke `final-review` now.
2. Complete its validation and review workflow.
3. Only then send the final answer.

If no material changes were made, say that `final-review` was not needed.

## Notes

- This hook is for users who want both reliable skill activation and an automatic end-of-task review.
- It is intended to replace `forced-eval-skill.md` when you want the extra final review behavior.
