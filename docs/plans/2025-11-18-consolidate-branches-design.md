# Branch Consolidation Skill Design

**Date**: 2025-11-18
**Type**: Skill
**Status**: Approved

## Overview

The `consolidate-branches` skill helps consolidate multiple PR branches onto a target branch using jj's multi-parent rebase capabilities with intelligent AI-powered conflict resolution. The primary use case is when multiple feature branches need to be merged together and conflicts are expected.

## Problem Statement

When working with multiple Claude Code sessions, users often end up with several hanging PR branches that need to be consolidated onto main. These branches may have overlapping changes that conflict. Manually merging them is tedious and error-prone.

The skill provides an AI assistant that:
- Discovers all branches needing consolidation
- Understands the intent behind each branch's changes
- Intelligently resolves conflicts by combining the intents
- Verifies all changes are properly consolidated

## Architecture

### 1. Discovery Phase

**Goal**: Find all branches that might need consolidation

**Implementation**:
- Run `jj git fetch` to sync with remote
- Execute `JJ_CONFIG= jj log -r "trunk()..@ | trunk() | @.."` to display branch structure
- Parse output to identify candidate branches
- Present branches with metadata (commit count, last change, branch name)

### 2. Selection Phase

**Goal**: Let user choose what to consolidate and where

**Implementation**:
- Use AskUserQuestion with multi-select for branch selection
- Prompt for target branch (default: main/trunk)
- Validate:
  - At least 2 branches selected
  - Target branch exists
  - Selected branches differ from target
- Show summary: "Consolidating branches [A, B, C] onto main"

### 3. Analysis Phase

**Goal**: Understand the intent behind each branch before merging

**Implementation**:
- For each selected branch:
  - Read commit messages
  - Examine PR descriptions (if available from remote)
  - Analyze diffs to understand what changed
  - Categorize change type (feature, bugfix, refactor, etc.)
  - Document the intent for later conflict resolution

### 4. Consolidation Phase

**Goal**: Combine all branches using multi-parent rebase

**Implementation**:
- Create new working commit: `jj new <target-branch>`
- Multi-parent rebase: `jj rebase -r @ -d branch1 -d branch2 -d branch3 ...`
- This creates an octopus-style merge point with all branches as parents

### 5. Intelligent Conflict Resolution

**Goal**: Resolve conflicts by understanding and combining intents

**Implementation**:
- When conflicts occur in a file:
  - Show conflict sections from each branch
  - Analyze the intent behind each conflicting change (using the analysis from Phase 3)
  - Propose an intelligent merge that preserves both/all intents
  - Apply resolution to the file
  - Track what was resolved and why

- Present resolutions to user:
  - Show each conflict that was found
  - Explain how it was resolved
  - Justify the resolution based on understood intent
  - Ask for confirmation

**Key Principle**: This is the main value of the skill. Don't just mechanically merge - understand what each branch is trying to accomplish and create a merge that fulfills all those goals.

### 6. Verification Phase

**Goal**: Ensure all changes from all branches are present

**Implementation**:
- For each selected branch:
  - Run `jj diff -r <branch>` to see changes introduced
  - Verify those changes exist in consolidated result
  - Report any missing changes (safety check)

- Generate summary report:
  - List all consolidated branches
  - Show total commit count
  - List conflicts resolved with explanations
  - Show final diff of consolidated changes

### 7. Completion Phase

**Goal**: Leave workspace ready for user review

**Implementation**:
- Don't auto-commit (user maintains control)
- Provide next steps guidance:
  - "Review the changes"
  - "You can commit, create PR, or make further edits"
- Clean, consolidated workspace ready for review

## Design Decisions

### Why Multi-Parent Rebase?

**Alternatives considered**:
1. Sequential rebasing (A→main, B→A, C→B)
2. Pre-flight conflict analysis before any rebasing
3. Hybrid approach

**Decision**: Multi-parent rebase from the start
- All conflicts appear together in one place
- Simpler workflow (one operation vs. multiple)
- Easier to understand the full scope of conflicts
- Natural fit for jj's capabilities

### Why Preserve Commit History?

**Alternatives considered**:
1. Squash per branch
2. Single squashed commit

**Decision**: Preserve all individual commits
- Better for review (see progression of changes)
- Better for git blame (know who changed what when)
- Can always squash later if desired
- Losing history is irreversible

### Why Intelligent Conflict Resolution?

**Alternatives considered**:
1. Abort on any conflict
2. Leave conflicts for manual resolution

**Decision**: AI-powered intelligent resolution
- This is the primary use case (conflicts are expected)
- AI can understand intent better than mechanical merge
- Provides real value beyond what user can easily do manually
- Still presents resolutions for user validation

### Why Just Consolidate (No Auto-Commit)?

**Alternatives considered**:
1. Auto-commit with generated message
2. Auto-commit + auto-create PR

**Decision**: Leave workspace ready for review
- User maintains full control
- Can review AI's conflict resolutions
- Can make additional edits if needed
- Can craft appropriate commit message for context

## Success Criteria

The skill is successful if it:
1. Correctly discovers and presents available branches
2. Successfully consolidates non-conflicting branches
3. Intelligently resolves conflicts by understanding intent
4. Verifies all changes are present in the result
5. Leaves workspace in clean, reviewable state
6. Saves user significant time vs. manual merging

## Future Enhancements

Potential improvements for future iterations:
- Integration with GitHub/Gitea to fetch PR descriptions
- Support for partial branch consolidation (select specific commits)
- Automatic test running after consolidation
- Conflict difficulty assessment (warn if resolution is uncertain)
- Learning from user's manual conflict resolutions
