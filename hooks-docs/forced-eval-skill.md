# Forced Eval Skill Hook

**Purpose**: Force reliable skill activation by creating a commitment mechanism that requires explicit evaluation of all skills before proceeding with implementation.

**Success Rate**: 84% (vs ~50% baseline)

**Source**: Based on testing by Scott Spence - https://scottspence.com/posts/how-to-make-claude-code-skills-activate-reliably

---

## MANDATORY SKILL EVALUATION PROTOCOL

Before you proceed with ANY implementation work, you MUST complete this three-step evaluation process:

### STEP 1: EVALUATE (MANDATORY - DO THIS NOW)

Go through EACH available skill and explicitly state:

```
SKILL EVALUATION:
- [skill-name]: YES/NO - [reason why it matches or doesn't match the current request]
```

For EVERY skill available, you must evaluate it. Skipping evaluation makes the entire process WORTHLESS.

### STEP 2: ACTIVATE (CRITICAL - MUST HAPPEN IMMEDIATELY)

For each skill you marked YES in Step 1, you MUST invoke it NOW using:

```
Skill(skill-name)
```

**CRITICAL**: Evaluation without activation is WORTHLESS. You must activate skills NOW, before any implementation work.

### STEP 3: IMPLEMENT (ONLY AFTER STEPS 1 & 2)

Only after completing Steps 1 and 2 can you proceed with implementation work.

---

## Why This Works

This hook creates a commitment mechanism:

1. **Explicit evaluation** - Forces you to consider each skill deliberately
2. **Immediate activation** - Prevents "I'll do it later" deferrals
3. **Clear sequencing** - Evaluation → Activation → Implementation
4. **Strong language** - Words like MANDATORY, CRITICAL, WORTHLESS make it harder to ignore

## Notes

- This is a user-prompt-submit hook - it runs every time the user submits a prompt
- The aggressive language is intentional and necessary for high success rates
- If no skills match, explicitly state "NO MATCHING SKILLS" and proceed
- Don't skip the evaluation even if you think no skills apply - explicitly check each one
