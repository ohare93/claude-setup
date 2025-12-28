---
description: Stage all changes, create commit, and push to remote (use with caution)
---

# Commit and Push Everything

**CAUTION**: Commit all working copy changes and push to remote. Use only when confident all changes belong together.

## Workflow

### 1. Analyze Changes

Run in parallel:
- `jj status` - Show modified/added/deleted files
- `jj diff --stat` - Show change statistics
- `jj log -n 3` - Show recent commits for message style

### 2. Safety Checks

**STOP and WARN if detected:**
- Secrets: `.env*`, `*.key`, `*.pem`, `credentials.json`, `secrets.yaml`, `id_rsa`, `*.p12`, `*.pfx`, `*.cer`
- API Keys: Any `*_API_KEY`, `*_SECRET`, `*_TOKEN` variables with real values (not placeholders like `your-api-key`, `xxx`, `placeholder`)
- Large files: `>10MB` without Git LFS
- Build artifacts: `node_modules/`, `dist/`, `build/`, `__pycache__/`, `*.pyc`, `.venv/`
- Temp files: `.DS_Store`, `thumbs.db`, `*.swp`, `*.tmp`

**API Key Validation:**

Check modified files for patterns like:
```bash
OPENAI_API_KEY=sk-proj-xxxxx  # Real key detected!
AWS_SECRET_KEY=AKIA...         # Real key detected!
STRIPE_API_KEY=sk_live_...    # Real key detected!

# Acceptable placeholders:
API_KEY=your-api-key-here
SECRET_KEY=placeholder
TOKEN=xxx
API_KEY=<your-key>
SECRET=${YOUR_SECRET}
```

**Verify:**
- `.gitignore` properly configured
- No merge conflicts
- Correct branch (warn if main/master)
- API keys are placeholders only

### 3. Request Confirmation

Present summary:
```
Changes Summary:
- X files modified, Y added, Z deleted
- Total: +AAA insertions, -BBB deletions

Safety: [status] No secrets | [status] No large files | [warnings]
Branch: [name] -> origin/[name]

I will: jj commit -> jj git push

Type 'yes' to proceed or 'no' to cancel.
```

**WAIT for explicit "yes" before proceeding.**

### 4. Generate Commit Message

Analyze changes and create conventional commit:

**Format:**
```
[type]: Brief summary (max 72 characters)

- Key change 1
- Key change 2
- Key change 3
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `build`, `ci`

**Example:**
```
docs: Update concept README files with comprehensive documentation

- Add architecture diagrams and tables
- Include practical examples
- Expand best practices sections
```

### 5. Commit and Push

```bash
jj commit -m "[Generated commit message]"
jj git push
jj log -n 1  # Verify
```

### 6. Confirm Success

```
Successfully pushed to remote!

Commit: [hash] [message]
Branch: [branch] -> origin/[branch]
Files changed: X (+insertions, -deletions)
```

## Error Handling

- **jj commit fails**: Check for conflicts, verify working copy state with `jj status`
- **jj git push fails**:
  - Non-fast-forward: `jj git fetch` then `jj rebase -d main` then retry push
  - No remote branch: `jj git push --allow-new`
  - Protected branch: Use PR workflow instead

## When to Use

**Good:**
- Multi-file documentation updates
- Feature with tests and docs
- Bug fixes across files
- Project-wide formatting/refactoring
- Configuration changes

**Avoid:**
- Uncertain what's being committed
- Contains secrets/sensitive data
- Protected branches without review
- Merge conflicts present
- Want granular commit history
- Pre-commit hooks failing

## Alternatives

If user wants control, suggest:
1. **Selective commits**: Review specific files with `jj split`
2. **Interactive editing**: Use `jj squash` to combine commits
3. **PR workflow**: Create branch -> push -> PR

**Remember**: Always review changes before pushing. When in doubt, use individual jj commands for more control.
