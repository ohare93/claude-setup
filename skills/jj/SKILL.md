---
name: jj
description: Use when working with version control. jj (Jujutsu) is the preferred VCS - never use git commands directly when jj can do the job. Covers mental model, workflows, and Nix integration.
---

# Jujutsu (jj) Version Control

**CRITICAL**: Always use jj instead of git. Never run git commands directly when a jj command will do.

## Mental Model (Key Differences from Git)

Understanding these concepts prevents most jj mistakes:

### 1. Working Copy IS a Commit
- In jj, your working directory is always a commit (the "working copy commit")
- There's no concept of "uncommitted changes" - edits are automatically part of the working copy commit
- Changes are snapshotted automatically when you run jj commands

### 2. No Staging Area
- Everything is auto-tracked - no `git add` needed
- Files are either tracked or ignored (via `.gitignore`)
- To commit partial changes, use `jj split`

### 3. `jj new` Creates Empty Commits
- `jj new` creates a new empty commit ON TOP of the current one
- Your previous work stays in the parent commit
- Think of it as "I'm done with this commit, start fresh work"

### 4. Bookmarks, Not Branches
- jj uses "bookmarks" which are just pointers to commits
- There's no "current branch" concept
- You work on commits directly, bookmarks are optional labels

### 5. Automatic Rebasing
- When you edit a commit, all descendants are automatically rebased
- No manual `git rebase` needed for most cases

## Nix Integration (Critical Gotcha)

**Problem**: Nix flakes only see files tracked in git HEAD. New files are invisible to Nix until snapshotted.

**Symptoms**:
- `nix build` fails with "file not found" for newly created files
- `nix flake check` doesn't see your changes
- Module imports fail for new `.nix` files

**Solution**: Snapshot working copy before Nix commands:
```bash
# Option 1: Create new commit (moves your work to parent)
jj new

# Option 2: Commit with message (same effect)
jj commit -m "wip"

# Then run nix
nix build
nix flake check
```

**Why this works**: `jj new` or `jj commit` snapshots the working copy, which updates git HEAD (jj's colocated git repo), making files visible to Nix.

## Command Mappings

| Task | Git | jj |
|------|-----|-----|
| Start work | `git checkout -b feat` | `jj new -m "feat"` |
| Stage + commit | `git add . && git commit` | `jj commit -m "msg"` |
| Amend | `git commit --amend` | Just edit files (auto-amended) or `jj describe` |
| Partial commit | `git add -p` | `jj split` |
| Interactive rebase | `git rebase -i` | `jj rebase` (auto-rebases descendants) |
| Undo | `git reset/reflog` | `jj undo` or `jj op restore` |
| Status | `git status` | `jj st` |
| Log | `git log` | `jj log` |
| Diff | `git diff` | `jj diff` |
| Create branch | `git branch foo` | `jj bookmark create foo` |
| Switch branch | `git checkout foo` | `jj edit foo` (or `jj new foo`) |
| Push | `git push` | `jj git push` |
| Pull | `git pull` | `jj git fetch && jj rebase -d main` |
| Merge | `git merge` | `jj new commit1 commit2` (creates merge commit) |
| Stash | `git stash` | Not needed - just `jj new` and come back |

## Key Workflows

### Starting Fresh Work
```bash
jj new main -m "feat: add user authentication"
# Now working on a new commit based on main
```

### Editing an Old Commit
```bash
jj log                    # Find the change-id (e.g., xyz)
jj edit xyz               # Switch to that commit
# Make your edits - they're automatically part of that commit
jj new                    # When done, go back to a new commit
```

### Squashing Commits
```bash
jj squash                 # Squash current into parent
jj squash --into @-       # Same thing, explicit
jj squash --from xyz      # Squash specific commit into parent
```

### Splitting a Commit
```bash
jj split                  # Interactive split of current commit
# Select which changes go in the first commit
# Remaining changes stay in a second commit
```

### Resolving Conflicts
```bash
# Conflicts are stored IN commits (not blocking)
jj log                    # See which commits have conflicts
jj resolve                # Interactive conflict resolution
jj resolve --tool meld    # Use specific merge tool
```

### Working with Bookmarks (Branches)
```bash
jj bookmark create feat-auth     # Create bookmark at current commit
jj bookmark move feat-auth       # Move bookmark to current commit
jj bookmark list                 # List all bookmarks
jj git push -b feat-auth         # Push specific bookmark
```

### Undoing Mistakes
```bash
jj undo                   # Undo last operation
jj op log                 # See operation history
jj op restore <op-id>     # Restore to specific operation
```

## Common Patterns

### "I want to save my work but keep editing"
Just keep editing - it's auto-saved in the working copy commit. Use `jj describe` to update the message.

### "I want to try something without losing current work"
```bash
jj new                    # Your work is safe in parent
# Experiment here
jj abandon                # Discard experiment
jj edit @-                # Go back to previous work
```

### "I need to switch contexts"
```bash
jj new                    # Snapshot current work
jj new other-commit       # Start from different point
# Do other work
jj new previous-work      # Return to original work
```

### "I accidentally edited the wrong commit"
```bash
jj undo                   # Just undo
```

## Run Tests After Changes

Always run unit tests after making logic changes to code. This applies regardless of version control system.
