---
description: Analyze all active juggler balls and create a comprehensive execution plan
---

# Juggle Plan All Command

**Task**: Analyze all active juggler balls in the current project and create a comprehensive execution plan.

## Objective

Review all active tasks (balls) being juggled and create a prioritized, structured plan for completing them efficiently.

## Execution Steps

### Step 1: Gather Ball Data

Run the following command to export all active balls:

```bash
juggle export --format json
```

This will output JSON data containing all balls (excluding completed/done by default).

### Step 2: Analyze Balls

Review the exported ball data and identify:

**Ball Properties to Consider**:
- `id` - Ball identifier
- `intent` - What the ball is trying to accomplish
- `priority` - high/medium/low priority
- `active_state` - Current state (ready/juggling)
- `juggle_state` - Sub-state (needs-thrown/in-air/needs-caught)
- `todos` - Specific tasks within the ball (if present)
- `last_activity` - When the ball was last touched
- `zellij_session`/`zellij_tab` - Context information

**Analysis Criteria**:
1. **State Priority**:
   - `needs-caught` balls should be addressed first (work completed, needs verification)
   - `needs-thrown` balls need direction/input next
   - `in-air` balls are actively being worked on
   - `ready` balls haven't been started yet

2. **Priority Levels**:
   - High priority balls should be tackled before medium/low
   - Consider if priority conflicts with state priority

3. **Dependencies**:
   - Look for balls that reference similar components/files
   - Identify balls that might block or enable other balls
   - Note balls with todos that relate to other balls' intents

4. **Completeness**:
   - Balls with todos: Check how many are completed vs pending
   - Balls near completion should generally be prioritized

### Step 3: Create Structured Plan

Generate a comprehensive plan with the following sections:

**1. Executive Summary**:
- Total number of active balls
- Breakdown by state (needs-caught, needs-thrown, in-air, ready)
- Breakdown by priority

**2. Ball Groups** (organize by theme/component):
- Group related balls together
- Identify common themes (e.g., CLI improvements, refactoring, bug fixes)
- Note dependencies between groups

**3. Recommended Execution Order**:
For each ball in suggested order, provide:
- Ball ID and intent
- Current state and why it's positioned here
- Key todos or next actions
- Estimated complexity (if discernible)
- Dependencies or blockers

**4. Quick Wins**:
- Identify balls that are nearly complete
- Highlight balls that unblock others
- Note any balls in `needs-caught` state that just need verification

**5. Parking Lot**:
- Balls that can wait (low priority + not blocking)
- Balls that need more information (needs-thrown with unclear direction)

### Step 4: Present Recommendations

After presenting the plan, provide:

**Immediate Next Steps**:
- Which ball(s) to address first and why
- Specific commands to run (e.g., `juggle juggler-8 in-air`)
- Any preparation needed before starting

**Workflow Suggestion**:
- Should balls be tackled sequentially or can some be parallelized?
- Are there natural break points for user review?
- When should `/split-plan` be invoked to delegate to specialized agents?

## Output Format

Structure your response as:

```
# Juggler Plan Analysis

## Executive Summary
[Stats and overview]

## Active Ball Groups

### Group 1: [Theme Name]
**Balls**: juggler-X, juggler-Y
**Dependencies**: [Any dependencies]
**Description**: [What these balls accomplish together]

### Group 2: [Theme Name]
...

## Recommended Execution Order

1. **juggler-X**: [Intent]
   - State: [Current state]
   - Priority: [Priority level]
   - Next Action: [What to do]
   - Why First: [Reasoning]

2. **juggler-Y**: [Intent]
   ...

## Quick Wins
- [Balls that can be completed quickly]

## Parking Lot
- [Balls that can wait]

## Immediate Next Steps
1. [First action]
2. [Second action]
3. [When to use /split-plan]
```

## Success Criteria

- All active balls are accounted for in the plan
- Execution order has clear reasoning based on priority, state, and dependencies
- User has actionable next steps
- Plan identifies which balls should be tackled immediately vs later
- Dependencies and blockers are clearly identified
