# Best Practices and Learnings

This document captures hard-won knowledge from working with various tools and configurations. These are specific solutions to real problems encountered during development.

## Kanata Keyboard Configuration

### Danish Keyboard Layout (ThinkPad T14s)

**Physical Layout Understanding:**
- Top row: `q w e r t y u i o ø å ¨` (positions 1-12)
- Home row: `a s d f g h j k l ø æ '` (where ø is KeyL, æ is Semicolon, ' is Quote)
- Danish keyboard differs from US layout in positions 10-13 of top row and 10-12 of home row

**Critical Kanata Keycodes for Danish Layout:**
- `KeyO` = physical 'o' key (position 9 top row)
- `KeyP` = physical 'p' key (position 10 top row, produces ø on Danish layout)
- `BracketLeft` = physical 'å' key (position 11 top row)
- `BracketRight` = physical '¨' key (position 12 top row)
- `KeyL` = physical 'l' key (position 9 home row)
- `Semicolon` = physical 'æ' key (position 10 home row)
- `Quote` = physical 'ø' key on home row (position 11 home row)
- `Backslash` = physical ''' key (position 12 home row)

**Character vs Keycode Issue:**
- NEVER use literal characters like `'` in kanata mappings
- Characters are interpreted as "key that produces this character on current layout"
- Use proper keycodes instead: `'` → `apos`, not the literal character
- Example: `KeyP '` fails because `'` refers to Quote key position, use `KeyP apos`

**Working Configuration Structure:**
```
(defsrc
  tab q w e r t y u i KeyO KeyP BracketLeft BracketRight ret
  caps a s d f g h j k KeyL Semicolon Quote Backslash
)

(deflayermap colemak-dh
  KeyP apos  ; Physical P key produces apostrophe
  Quote apos ; Physical ø key produces apostrophe in colemak-dh
)
```

**Layer System:**
- Use `deflayermap` for complex layouts with long keycode names
- Space bar tap-hold: `(tap-hold 200 200 spc (layer-toggle lefthand))`
- Caps lock smart behavior: `(fork bspc caps (rsft))` - backspace with lshift, caps with rshift
- In lefthand layer: `caps ret` makes caps produce enter when space is held

**Home Row Modifiers:**
- `(tap-hold 200 200 <key> <modifier>)` for tap-hold behavior
- a/o keys: alt when held (`lalt`/`ralt`)
- r/i keys: ctrl when held (`lctl`/`rctl`)
- g/m keys: super when held (`lmet`/`rmet`)

**Debugging Tips:**
- Always check kanata service status: `systemctl status kanata-laptop.service`
- Look for "entering the processing loop" and "Starting kanata proper" in logs
- Use deflayermap when keycode names are long (KeyO, KeyP, etc.)
- Count defsrc items carefully - layer count mismatches cause build failures

**Bottom Row Remapping:**
- `102d` key is the `<>` key next to left shift on ISO keyboards
- Shifted bottom row: `< key→z, z→x, x→c, c→d, v→v, b→<`

**Mirror Layer Constraints:**
- User wants only pinkie-key mirroring: `a↔æ` (Semicolon key)
- NOT full mirroring - rest of hand stays in normal colemak-dh positions
- In lefthand layer: `a @o-alt  Semicolon @a-alt` for the a↔æ swap

## Hyprland Configuration

### Hyprland Version Compatibility

**Always validate configuration before using:**
```bash
hyprland -v  # Check version
hyprland --config ~/.config/hypr/hyprland.conf --verify-config  # Validate
```

### Deprecated Options in Hyprland 0.50.1+

**1. Shadow Configuration** - Must use nested format:
```nix
# OLD (deprecated):
decoration = {
  drop_shadow = true;
  shadow_range = 4;
  shadow_render_power = 3;
  "col.shadow" = "rgba(1a1a1aee)";
};

# NEW (correct):
decoration = {
  shadow = {
    enabled = true;
    range = 4;
    render_power = 3;
    color = "rgba(1a1a1aee)";
  };
};
```

**2. Master Layout Options:**
- `master.new_is_master` no longer exists - remove entirely
- Most users should use `dwindle` layout instead

**3. Window Rules Syntax:**
```nix
# OLD (causes "Invalid rulev2 syntax" errors):
windowrule = [
  "float, ^(pavucontrol)$"
];

# NEW (correct):
windowrule = [
  "float, class:^pavucontrol$"
];
```

### Terminal Application Issues

- Always ensure terminal emulator is installed in `home.packages`
- Prefer Wayland-native terminals: `foot`, `alacritty`, `kitty`
- Konsole requires KDE dependencies - avoid for minimal Wayland setups

### Keyboard Layout Considerations

- Set `kb_layout = "gb"` for UK/Danish keyboards (not "us")
- When using Kanata remapping, Hyprland still needs correct physical layout
- Keybinding symbols (like `/`) depend on physical keyboard layout

### Essential Startup Services

Always include in `exec-once`:
```nix
exec-once = [
  "nm-applet --indicator"  # Network/WiFi control
  "blueman-applet"         # Bluetooth control
  "waybar"                 # Status bar
];
```

Missing network applet = no WiFi control in Wayland

### Debugging Hyprland Issues

1. Check configuration: `hyprland --verify-config`
2. Look for logs in `$XDG_RUNTIME_DIR/hypr/`
3. Session errors: `journalctl --user -b 0 | grep -i hyprland`
4. Errors appear at top of screen on startup - fix immediately

## NixOS/Nix Configuration

### External Configuration Files

**Critical Rule**: External config files MUST be committed to git/jj before Nix can access them.

**Proper File Inclusion Pattern**:
```nix
# CORRECT: Use relative paths from the .nix file location
xdg.configFile."app/config.ext".source = ../config/file.ext;

# WRONG: Absolute paths break Nix reproducibility
xdg.configFile."app/config.ext".source = /home/user/nixfiles/config/file.ext;
```

### Building and Testing

Always test before switching:
```bash
# NixOS
sudo nixos-rebuild test --flake .#<hostname>

# Home Manager
home-manager build --flake .#jmo@<hostname> --no-out-link
```

## Docker/Container Best Practices

### Unraid Performance Optimization

- **Use `/mnt/cache/` instead of `/mnt/user/`** for appdata and cache
- `/mnt/cache/CacheWork/` bypasses Unraid's user share calculations
- This avoids Unraid checking which drive to store data on
- Significantly improves I/O performance

### Volume Mappings

**Always use absolute paths with .env file:**
```yaml
# Create .env file:
COMPOSE_DIR=/mnt/user/Syncthing/DockerUnraid/servicename

# In compose.yaml:
volumes:
  - ${COMPOSE_DIR}/config:/config
```

Prevents Docker context issues when running from different directories.

### Version Pinning

**Always use specific version tags, never "latest":**
```yaml
# GOOD
image: postgres:15.3-alpine

# BAD
image: postgres:latest
```

Prevents unexpected breaking changes.

## Traefik & Authelia Configuration

### Middleware Execution Order

Order matters! Traefik executes middleware left-to-right:
```yaml
traefik.http.routers.service.middlewares=my-geoblock@file,auth@file,securityHeaders@file
```

### Geoblock Plugin

**CRITICAL**: Set `allowLocalRequests: true` when used before authentication:
```yaml
my-geoblock:
  plugin:
    geoblock:
      allowLocalRequests: true  # Essential!
      allowedCountries: ["GB"]
```

Without this, local network requests are blocked before auth bypass can take effect.

### Authelia Access Control

API and registry endpoints need bypass rules for local networks:
```yaml
access_control:
  rules:
    - domain: "*.munchohare.com"
      resources:
        - "^/api([/?].*)?$"
        - "^/v2(/.*)?$"  # Docker registry
      networks:
        - 192.168.0.0/16
        - 10.0.0.0/8
        - 172.16.0.0/12
      policy: bypass
```

### IP Whitelist Middleware

Must include both local networks AND public IP:
```yaml
local-ipwhitelist:
  ipWhiteList:
    sourceRange:
      - 127.0.0.1/32
      - 192.168.0.0/16
      - 10.0.0.0/8
      - 172.16.0.0/12
      - 87.104.42.142/32  # Public IP for Cloudflare-routed traffic
```

## DNS Configuration

### Pi-hole and Cloudflare Interaction

**Services WITH Pi-hole DNS entry:**
```
Client → Pi-hole DNS → 192.168.0.105:443 → Traefik → Service
(Local routing, appears as local IP)
```

**Services WITHOUT Pi-hole DNS entry:**
```
Client → Cloudflare DNS → Public IP → Unraid:443 → Traefik → Service
(External routing, appears as public IP)
```

Docker containers use host DNS by default - may not use Pi-hole unless configured.

## Common Issues and Solutions

### 403 Forbidden from Docker Registry/API

**Symptom**: `docker login` fails with 403, or API calls get 403
**Cause**: Geoblock blocking local requests before auth bypass
**Fix**: Set `allowLocalRequests: true` in geoblock middleware
**Location**: `traefik/config/fileConfig.yml`

### Authentication Not Bypassing for Local Clients

**Possible causes**:
1. Traffic routing through Cloudflare (add public IP to networks or Pi-hole entry)
2. Geoblock blocking before Authelia (set `allowLocalRequests: true`)
3. Network ranges don't match client IP (check Authelia logs)

### Container Can't Reach Internal Services

**Symptom**: DNS errors or wrong IP
**Cause**: Docker uses host DNS, may not use Pi-hole
**Fix**: Add Pi-hole DNS entry OR configure container with custom DNS

## Version Control with Jujutsu (jj)

### Common Operations

```bash
# View commits from trunk
JJ_CONFIG= jj log --no-pager -s -r "trunk()..@"

# View single commit
jj diff -r REVID

# Set commit description
jj desc -r REVID -m "message"

# Push to remote
jj git push
```

### Conventional Commits

Format: `type(scope): description`

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `build`, `ci`

## Development Workflow

### Devbox and Environment Variables

**Initial testing**: OK to add env vars to commands
**Once working**: Make them permanent via devbox `init_hook`
**Documentation**: Create `.devbox/setup-*.sh` scripts

Never leave env vars in repeated command invocations - make them permanent.

### Testing Strategy

**Always run unit tests** after logic changes. This should be the common final task.

## Rust Development

### SQLx Migrations

**Runtime vs Compile-time Modes:**

SQLx has two distinct migration approaches with different behaviors:

**Compile-time Mode** (with `sqlx::query!` macro):
```rust
// Requires compile_error.txt in migrations/
sqlx::query!("SELECT * FROM users")
```
- Validates SQL at compile time
- Needs database connection during build
- Migrations must complete before compilation

**Runtime Mode** (with `sqlx::query` without macro):
```rust
// No compile_error.txt needed
sqlx::query("SELECT * FROM users")
```
- SQL validation happens at runtime
- Build doesn't need database
- Migrations run when app starts

**Key Learning**: If using runtime mode, don't add `compile_error.txt` to migrations - it will cause unnecessary build failures.

### Axum Error Handling and Send Trait

**Problem**: Axum requires error types to implement `Send` trait for async handlers.

**Symptom**:
```rust
// This fails:
type BoxError = Box<dyn std::error::Error>;

async fn handler() -> Result<String, BoxError> {
    Err("error")?  // Error: BoxError doesn't implement Send
}
```

**Cause**: `Box<dyn Error>` isn't automatically `Send` because the trait object might contain non-Send types.

**Fix**:
```rust
// Specify Send + Sync bounds:
type BoxError = Box<dyn std::error::Error + Send + Sync>;

async fn handler() -> Result<String, BoxError> {
    Err("error")?  // ✓ Works
}
```

**Rule**: Always add `+ Send + Sync` to boxed error trait objects in async Rust code.

## Elm and Gren Development

### Gren vs Elm Syntax Differences

Gren is an Elm fork with modernized syntax. Key differences:

**1. Record Updates:**
```elm
-- Elm:
{ model | count = model.count + 1 }

-- Gren:
{ model | count <- model.count + 1 }  -- Uses <- instead of =
```

**2. Lambda Syntax:**
```elm
-- Elm:
List.map (\x -> x + 1) numbers

-- Gren:
Array.map (\x -> x + 1) numbers  -- Array instead of List
```

**3. Collection Types:**
- Elm uses `List` for sequences
- Gren uses `Array` for sequences (better performance)

**4. Port Definitions:**
```elm
-- Elm:
port sendMessage : String -> Cmd msg

-- Gren:
-- Port syntax differs, check Gren docs
```

**Common Mistake**: Copying Elm code directly to Gren projects without updating syntax.

**Fix**: Always check Gren documentation when porting Elm code. The languages have diverged significantly.

## Python and CLI Tools

### yt-dlp Version Requirements

**Critical Issue**: Package manager versions of yt-dlp break frequently due to rapid changes in video platforms.

**Symptom**: Downloads fail with cryptic errors about JavaScript parsing or signature extraction.

**Root Cause**: Video platforms (YouTube especially) change their APIs/page structure frequently to combat downloaders.

**Solution**: Always use the latest version from GitHub master:
```bash
# In devbox.json:
{
  "packages": [
    "github:yt-dlp/yt-dlp"  # NOT nixpkgs#yt-dlp
  ]
}
```

**Why**: GitHub master gets fixes within hours/days, while package managers lag by weeks/months.

**Rule**: For any tool that interacts with rapidly-changing web services (downloaders, scrapers), prefer:
1. GitHub master/main branch
2. Direct installation from upstream
3. Regular auto-updates

Never rely on stable package versions for web scraping tools.

## When to Update This Document

Add entries when you:
- Spend >30 minutes debugging a non-obvious issue
- Discover a configuration gotcha
- Learn a tool-specific best practice
- Find a solution that isn't well documented
- Encounter version-specific breaking changes
