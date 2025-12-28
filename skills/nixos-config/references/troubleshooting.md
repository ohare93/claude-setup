# Troubleshooting Reference

## Debugging Workflow

When a build fails, follow this sequence:

1. **Read the error** — Nix errors include the file, line, and option path
2. **Evaluate in isolation** — test the failing expression with `nix-instantiate --eval`
3. **Explore interactively** — use `nix repl` to inspect values
4. **Inspect derivations** — use `nix show-derivation` if the issue is in the build phase
5. **Fix and rebuild**

## Error Message Catalog

### Evaluation Errors

**`error: attribute 'X' missing`**

Cause: referencing an attribute that doesn't exist in the set.

```
error: attribute 'myPackage' missing
       at /nix/store/.../configuration.nix:12:5
```

Fix: check spelling, verify the attribute exists in the set. Use `nix repl` to inspect:

```
nix-repl> pkgs ? myPackage
false
nix-repl> # try searching
nix-repl> builtins.filter (x: builtins.match ".*mypack.*" x != null) (builtins.attrNames pkgs)
```

---

**`error: infinite recursion encountered`**

Cause: a value depends on itself, directly or through a chain.

Common triggers:
- Using `rec` where attributes reference each other cyclically
- Module options that depend on their own config value
- Overlays where `final` and `prev` are confused

Fix: restructure to break the cycle. Use `let/in` instead of `rec`. Separate option declaration from usage.

---

**`error: value is a string while a set was expected`** (or similar type mismatches)

Cause: passing the wrong type to an option or function.

Fix: check the expected type in the option declaration. Use `builtins.typeOf` in `nix repl` to inspect values.

---

**`error: undefined variable 'X'`**

Cause: variable not in scope.

Fix: check for missing `let` bindings, missing function arguments, or missing `inherit` statements.

---

**`error: syntax error, unexpected X`**

Cause: Nix syntax error.

Common issues:
- Missing semicolons after `let` bindings or set attributes
- Missing commas in function argument patterns (they use commas, not semicolons)
- Unmatched brackets or braces

---

### File and Path Errors

**`error: getting status of '/nix/store/.../<file>': No such file or directory`**

Cause: the file exists on disk but is not tracked by git. Flakes only see files known to git.

Fix:

```bash
jj new    # snapshot to add new files to git HEAD
```

---

**`error: path '/path/to/file' does not exist`**

Cause: a relative path in a Nix expression points to a file that doesn't exist.

Fix: verify the file exists at the expected relative path from the Nix file.

---

### Flake Errors

**`error: flake 'X' does not provide attribute 'Y'`**

Cause: the flake output path is wrong.

Fix: check the exact output name. Run `nix flake show` to see available outputs.

```bash
nix flake show
```

---

**`error: input 'X' has an override but no matching input`**

Cause: `follows` references a non-existent input.

Fix: check input names in `follows` declarations match actual input names.

---

**`warning: Git tree '/path' is dirty`**

Not an error — just means uncommitted changes exist. Nix still evaluates but uses the working tree state.

---

### Build Errors

**`error: collision between '/nix/store/...' and '/nix/store/...'`**

Cause: two packages provide the same file path.

Fix: use `lib.hiPrio` on the preferred package, or exclude one:

```nix
environment.systemPackages = [
  (lib.hiPrio pkgs.preferred-package)
  pkgs.other-package
];
```

---

**`builder for '/nix/store/...' failed with exit code 1`**

Cause: the build script of a derivation failed.

Fix: check the build log:

```bash
nix log /nix/store/<hash>-<name>
```

---

### Option Errors

**`error: The option 'X' does not exist`**

Cause: the module declaring the option isn't imported, or the option path is wrong.

Fix: verify the module is in the `imports` list. Check the option path matches the declaration.

---

**`error: The option 'X' is used but not defined`**

Same as above — the option is referenced in config but never declared.

---

**`error: A definition for option 'X' is not of type 'Y'`**

Cause: the value doesn't match the option's type declaration.

Fix: check what type the option expects and adjust the value.

## Interactive Debugging

### nix repl

```bash
nix repl
# Load a flake
nix repl .#

# In the repl
nix-repl> :l <nixpkgs>                    # load nixpkgs
nix-repl> pkgs.firefox.version            # inspect a value
nix-repl> builtins.typeOf config.services  # check types
nix-repl> :t someValue                    # show type
nix-repl> :doc lib.mkIf                   # show documentation
```

### nix-instantiate

```bash
# Evaluate an expression
nix-instantiate --eval -E '1 + 1'

# Evaluate from a file
nix-instantiate --eval ./test.nix

# Strict evaluation (force all values)
nix-instantiate --eval --strict -E '{ a = 1; b = 2; }'

# JSON output
nix-instantiate --eval --json -E '{ a = 1; }'
```

### nix show-derivation

```bash
# Show what a derivation will build
nix show-derivation nixpkgs#firefox

# Show a specific store path
nix show-derivation /nix/store/<hash>-<name>
```

## Performance Issues

### Slow Evaluation

- **Large `rec` sets** — convert to `let/in`
- **Unnecessary imports** — only import what's needed
- **Deep `builtins.fetchurl`** — these block evaluation

### Large Closures

Check closure size:

```bash
nix path-info -rS /nix/store/<path> | sort -nk2 | tail -20
```

Reduce by:
- Using `buildInputs` instead of `propagatedBuildInputs` where possible
- Avoiding runtime dependencies on build tools

## Migration Patterns

### Channels to Flakes

Replace `<nixpkgs>` references:

```nix
# Old (channels)
{ pkgs ? import <nixpkgs> {} }:

# New (flakes)
# In flake.nix, pass pkgs through modules
{ config, pkgs, ... }:
```

### nix-env to Declarative

Replace imperative installs:

```bash
# Old
nix-env -iA nixpkgs.firefox

# New — in configuration.nix or home.nix
environment.systemPackages = [ pkgs.firefox ];
# or
home.packages = [ pkgs.firefox ];
```

### Deprecated Options

When nixos-rebuild warns about deprecated options:
1. Read the deprecation message — it usually suggests the replacement
2. Search NixOS options: `nixos-option services.X` or check the NixOS options search website
3. Update to the new option path
