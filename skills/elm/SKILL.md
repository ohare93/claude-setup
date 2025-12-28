---
name: elm
description: Use when working with Elm projects. Requires running elm-test and elm-review for quality assurance.
---

# Elm Development

## Required Tools

Always use these tools when working on Elm projects:

### elm-test

Run tests after making changes:

```bash
elm-test
```

### elm-review

Run static analysis after making changes:

```bash
elm-review
```

## Workflow

1. Make your changes to `.elm` files
2. Run `elm-test` to verify tests pass
3. Run `elm-review` to catch common issues
4. Fix any reported problems before considering the task complete

## Common Commands

```bash
elm make src/Main.elm           # Compile
elm reactor                     # Development server
elm-test                        # Run tests
elm-review                      # Static analysis
elm-review --fix                # Auto-fix issues
elm install <package>           # Install package
```
