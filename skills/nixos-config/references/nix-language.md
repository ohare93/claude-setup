# Nix Language Reference

## Basic Types

```nix
# Strings
"hello world"
''
  multi-line
  string
''
"string ${interpolation}"

# Numbers
42
3.14

# Booleans
true
false

# Null
null

# Paths (resolved relative to the file)
./relative/path
/absolute/path
```

## Let / In

Bind local variables:

```nix
let
  name = "world";
  greeting = "hello ${name}";
in
  greeting
# => "hello world"
```

## With

Bring an attrset's attributes into scope:

```nix
with pkgs; [ firefox git vim ]
# equivalent to: [ pkgs.firefox pkgs.git pkgs.vim ]
```

## Inherit

Copy attributes from surrounding scope or another set:

```nix
let name = "foo"; in
{ inherit name; }
# => { name = "foo"; }

{ inherit (pkgs) git vim; }
# => { git = pkgs.git; vim = pkgs.vim; }
```

## Recursive Attribute Sets

```nix
rec {
  x = 1;
  y = x + 1;  # can reference x
}
```

Avoid `rec` when possible — use `let/in` instead to prevent accidental infinite recursion.

## Functions

```nix
# Single argument
x: x + 1

# Multiple arguments (curried)
x: y: x + y

# Attrset pattern
{ name, value }: "${name}=${value}"

# With default
{ name, value ? "default" }: "${name}=${value}"

# With extra attributes allowed
{ name, ... }: name

# Named pattern
args@{ name, ... }: name
# or
{ name, ... }@args: name
```

## Attribute Set Operations

```nix
# Access
set.key
set."key with spaces"
set.${dynamicKey}

# Has attribute
set ? key

# Merge (right takes precedence)
set1 // set2

# Nested access with fallback
set.a.b or "default"
```

## List Operations

```nix
# Concatenation
[ 1 2 ] ++ [ 3 4 ]

# Common builtins
builtins.map (x: x + 1) [ 1 2 3 ]       # => [ 2 3 4 ]
builtins.filter (x: x > 2) [ 1 2 3 4 ]   # => [ 3 4 ]
builtins.length [ 1 2 3 ]                 # => 3
builtins.elem 2 [ 1 2 3 ]                # => true
builtins.head [ 1 2 3 ]                  # => 1
builtins.tail [ 1 2 3 ]                  # => [ 2 3 ]
```

## Key Builtins

```nix
builtins.toString 42               # => "42"
builtins.typeOf "hello"            # => "string"
builtins.attrNames { a = 1; b = 2; }  # => [ "a" "b" ]
builtins.attrValues { a = 1; b = 2; } # => [ 1 2 ]
builtins.hasAttr "a" { a = 1; }   # => true
builtins.readFile ./file.txt       # read file contents
builtins.toJSON { a = 1; }        # => "{\"a\":1}"
builtins.fromJSON "{\"a\":1}"     # => { a = 1; }
builtins.fetchurl { url = "..."; sha256 = "..."; }
```

## Import and Path Expressions

```nix
# Import a Nix file (evaluates it)
import ./module.nix

# Import with arguments
import ./module.nix { inherit pkgs; }

# Path concatenation
./. + "/filename"    # resolves to ./filename

# String-to-path (avoid in flakes — impure)
/. + builtins.toPath "/some/path"
```

## Conditionals

```nix
if condition then value1 else value2
```

## Assert

```nix
assert condition; value
# evaluates to value if condition is true, error otherwise
```

## Common lib Functions

```nix
lib.mkIf condition value
lib.mkDefault value
lib.mkForce value
lib.mkMerge [ config1 config2 ]
lib.mkEnableOption "description"
lib.mkOption { type = ...; default = ...; description = ...; }
lib.optional condition value         # => [ value ] or [ ]
lib.optionals condition list         # => list or [ ]
lib.optionalString condition str     # => str or ""
lib.optionalAttrs condition set      # => set or { }
lib.concatStringsSep ", " [ "a" "b" ] # => "a, b"
lib.concatMapStringsSep "\n" fn list
lib.mapAttrs (name: value: ...) set
lib.filterAttrs (name: value: ...) set
lib.attrValues set
lib.unique list
lib.flatten [ [ 1 ] [ 2 3 ] ]       # => [ 1 2 3 ]
```
