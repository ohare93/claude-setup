---
description: Assess the current repo and recommend which plugins to enable at the project level
---

# Setup Plugins

Analyze the current repository and recommend which globally-disabled plugins should be enabled for this project.

## Phase 1: Repo Scan

Build a tech profile of the current repository. Check for these patterns:

| Pattern | Indicates |
|---------|-----------|
| `*.tsx`, `*.jsx`, `*.vue`, `*.svelte` | Frontend framework |
| `*.css`, `*.scss`, `tailwind.config.*` | Styling/CSS |
| `*.test.*`, `*.spec.*`, `__tests__/`, `cypress/`, `playwright/` | Testing |
| `Dockerfile`, `docker-compose.*`, YAML files with k8s kinds | Containers/orchestration |
| `terraform/`, `*.tf`, `pulumi/`, `cdk.json` | Infrastructure as code |
| `*.py`, `requirements.txt`, `pyproject.toml` | Python |
| `*.go`, `go.mod` | Go |
| `*.rs`, `Cargo.toml` | Rust |
| `*.elm`, `elm.json` | Elm |
| `*.nix`, `flake.nix` | Nix |
| `*.ts`, `*.js`, `package.json` | JavaScript/TypeScript |
| `.github/workflows/`, `.gitlab-ci.yml` | CI/CD |
| `docs/`, many `*.md` files | Documentation-heavy |
| `*.swift`, `*.xcodeproj` | iOS/Swift |
| `*.dart`, `pubspec.yaml` | Flutter |

Also read `README.md` and the primary config file (`package.json`, `pyproject.toml`, `Cargo.toml`, etc.) for project purpose context.

Produce a one-line profile summary like: "Python FastAPI backend with Docker, Terraform infra, pytest tests, GitHub Actions CI."

## Phase 2: Plugin Scan

Discover what plugins are available and what they offer.

1. Read `~/.claude/settings.json` and extract the `enabledPlugins` map — this tells you every plugin key (format: `<plugin>@<marketplace>`) and whether it's globally enabled or disabled
2. For each disabled plugin, locate its files at `~/.claude/plugins/cache/<marketplace>/<plugin>/` — find the latest version directory inside
3. Read the plugin's `README.md` or top-level `SKILL.md` (first 100 lines only — enough to get the description and purpose)
4. Skip plugins that are already globally enabled — they're already loaded, no action needed
5. Also skip plugins already enabled in the project's `.claude/settings.local.json` if it exists

Produce a plugin capability map — one line per disabled plugin with its full key, estimated token cost, and what it covers.

## Phase 3: Match and Recommend

Using the repo profile from Phase 1 and the plugin capability map from Phase 2, reason about which disabled plugins would benefit this project.

For each disabled plugin, assess: does this repo have files, patterns, or purposes that align with what this plugin provides?

Present a table to the user:

```
Recommended plugins for this project:

  Plugin                 Tokens    Reason
  superpowers            135K      Has tests and CI — TDD and debugging workflows apply
  cloud-infrastructure   434K      Dockerfile + Terraform detected

Not recommended:
  document-skills        325K      No document generation needs detected
  ui-ux-pro-max          144K      No frontend components detected
  elements-of-style       19K      Not documentation-heavy
```

## Phase 4: Gap Analysis

After matching, consider whether the repo has needs that none of the installed plugins cover.

Look for:
- Languages or frameworks with no matching plugin
- Workflow patterns (e.g. monorepo, microservices) with no tooling support
- Domain-specific needs (ML, data pipelines, mobile) without coverage

If gaps are found, present them:

```
Potential gaps (no installed plugin covers these):
  - FastAPI-specific tooling (Python API framework)
  - Helm chart management (charts/ directory detected)
```

Then ask: "Want me to search for plugins that cover these gaps?"

If the user says yes, do a web search for Claude Code plugins/skills matching each gap and present findings.

If no gaps are found, skip to Phase 5.

## Phase 5: Apply

Ask the user to confirm or adjust the recommendations. They can accept all, remove individual items, or add from the "not recommended" list.

On confirmation:

1. Read existing `.claude/settings.local.json` in the current project directory (create `{"enabledPlugins": {}}` if missing)
2. For each confirmed plugin, add its full key (e.g. `superpowers@superpowers-marketplace`) set to `true` under `enabledPlugins`
3. Write the updated `.claude/settings.local.json`
4. Report what was enabled with token costs and remind to restart the session

Example output:

```
Enabled in .claude/settings.local.json:
  + superpowers@superpowers-marketplace
  + cloud-infrastructure@claude-code-workflows

Token budget for this project: +569K
Restart Claude Code to load the new plugins.
```
