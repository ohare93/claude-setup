---
description: Implement pre-commit hooks and GitHub Actions for quality assurance
---

# Setup CI/CD Pipeline

Implement comprehensive DevOps quality gates adapted to project type.

## Workflow

### 1. Analyze Project

Detect:
- Language(s) and framework
- Build system and package manager
- Existing tooling and configs

### 2. Configure Pre-commit Hooks

Install language-specific tools:

**Formatting:**
- JavaScript/TypeScript: Prettier
- Python: Black, isort
- Go: gofmt
- Rust: rustfmt

**Linting:**
- JavaScript/TypeScript: ESLint
- Python: Ruff
- Go: golangci-lint
- Rust: Clippy

**Security:**
- Python: Bandit
- Go: gosec
- Rust: cargo-audit
- Node: npm audit

**Type Checking (if applicable):**
- TypeScript: tsc
- Python: mypy
- JavaScript: flow

**Tests:**
- Run relevant test suites

### 3. Create GitHub Actions Workflows

Create `.github/workflows/` with:
- Mirror pre-commit checks on push/PR
- Multi-version/platform matrix (if applicable)
- Build and test verification
- Deployment steps (if needed)

### 4. Verify Pipeline

- Test locally with pre-commit hooks
- Create test PR
- Confirm all checks pass

## Guidelines

- Use free/open-source tools
- Respect existing configs
- Keep execution fast
