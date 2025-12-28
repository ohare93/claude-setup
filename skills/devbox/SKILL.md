---
name: devbox
description: Use when managing project dependencies with Devbox. Devbox is the preferred dependency manager for new projects - covers package installation, environment variables, and shell configuration.
---

# Devbox Dependency Management

**Devbox is the preferred dependency manager** for new projects. Use it to create reproducible development environments.

## When to Use Devbox vs Other Tools

| Scenario | Tool |
|----------|------|
| New project setup | Devbox |
| Existing project with `devbox.json` | Devbox |
| Existing project with `flake.nix` (no devbox) | `nix develop` |
| Existing project with other setup | Follow their setup |

## Adding Packages

**CRITICAL**: Add packages one at a time. Adding multiple packages in a single command exceeds the 120s timeout.

```bash
# Correct - one package at a time
devbox add nodejs
devbox add python
devbox add postgresql

# Wrong - will timeout
devbox add nodejs python postgresql
```

### Finding Packages

```bash
devbox search <package-name>
```

## Environment Variables

### Testing First

Test environment variables in commands before making them permanent:

```bash
# Test that it works
DATABASE_URL=postgres://localhost/mydb devbox run npm start
```

### Making Permanent

Once confirmed working, add to `devbox.json` init_hook or setup scripts:

**Option 1: devbox.json init_hook**
```json
{
  "packages": ["nodejs", "postgresql"],
  "shell": {
    "init_hook": [
      "export DATABASE_URL=postgres://localhost/mydb",
      "export NODE_ENV=development"
    ]
  }
}
```

**Option 2: Setup scripts** (`.devbox/setup-*.sh`)
```bash
# .devbox/setup-env.sh
export DATABASE_URL=postgres://localhost/mydb
export NODE_ENV=development
```

### Anti-pattern

**Never** leave environment variables in repeated command invocations:

```bash
# Wrong - env var in every command
DATABASE_URL=x devbox run npm test
DATABASE_URL=x devbox run npm start
DATABASE_URL=x devbox run npm build

# Right - set once in init_hook, then just run
devbox run npm test
devbox run npm start
devbox run npm build
```

## Common Commands

```bash
devbox init              # Initialize devbox in current directory
devbox add <pkg>         # Add a package
devbox rm <pkg>          # Remove a package
devbox shell             # Enter devbox shell
devbox run <cmd>         # Run command in devbox environment
devbox services start    # Start background services
devbox services stop     # Stop background services
devbox update            # Update packages
```

## Project Structure

A devbox project typically has:

```
project/
├── devbox.json          # Package list and configuration
├── devbox.lock          # Locked versions
└── .devbox/
    ├── setup-env.sh     # Custom environment setup (optional)
    └── ...
```
