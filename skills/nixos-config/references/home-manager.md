# Home Manager Reference

## Module Structure

```nix
{ config, lib, pkgs, ... }:

{
  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
```

## Programs

Home Manager provides declarative configuration for many programs via `programs.*`:

```nix
# Git
programs.git = {
  enable = true;
  userName = "Name";
  userEmail = "email@example.com";
  extraConfig = {
    init.defaultBranch = "main";
    pull.rebase = true;
  };
  signing = {
    key = "KEYID";
    signByDefault = true;
  };
};

# Shell — Zsh
programs.zsh = {
  enable = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
  shellAliases = {
    ll = "ls -la";
    gs = "git status";
  };
  initExtra = ''
    # extra shell init
  '';
  oh-my-zsh = {
    enable = true;
    plugins = [ "git" "docker" ];
    theme = "robbyrussell";
  };
};

# Neovim
programs.neovim = {
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  plugins = with pkgs.vimPlugins; [
    telescope-nvim
    nvim-treesitter.withAllGrammars
  ];
  extraLuaConfig = ''
    -- lua config here
  '';
};

# Firefox
programs.firefox = {
  enable = true;
  profiles.default = {
    settings = {
      "browser.startup.homepage" = "https://example.com";
    };
    extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
    ];
  };
};

# Alacritty
programs.alacritty = {
  enable = true;
  settings = {
    font.size = 12;
    window.opacity = 0.95;
  };
};

# Tmux
programs.tmux = {
  enable = true;
  terminal = "screen-256color";
  keyMode = "vi";
  plugins = with pkgs.tmuxPlugins; [
    sensible
    yank
  ];
};

# Direnv
programs.direnv = {
  enable = true;
  nix-direnv.enable = true;
};
```

## Services

User-level services via `services.*`:

```nix
# SSH agent
services.ssh-agent.enable = true;

# GPG agent
services.gpg-agent = {
  enable = true;
  enableSshSupport = true;
  pinentryPackage = pkgs.pinentry-curses;
};

# Syncthing
services.syncthing.enable = true;

# Redshift / Gammastep
services.gammastep = {
  enable = true;
  latitude = 40.7;
  longitude = -74.0;
};
```

## Packages

```nix
home.packages = with pkgs; [
  ripgrep
  fd
  jq
  htop
  unzip
];
```

## File Management

### home.file

Place files relative to `$HOME`:

```nix
home.file = {
  ".config/my-app/config.toml".text = ''
    [settings]
    theme = "dark"
  '';

  ".local/bin/my-script" = {
    source = ./scripts/my-script.sh;
    executable = true;
  };

  "wallpaper.png".source = ./wallpaper.png;
};
```

### xdg.configFile

Place files relative to `$XDG_CONFIG_HOME` (usually `~/.config`):

```nix
xdg.configFile = {
  "my-app/config.toml".text = ''
    [settings]
    theme = "dark"
  '';

  "my-app/themes".source = ./themes;
  "my-app/themes".recursive = true;
};
```

### xdg.dataFile

Place files relative to `$XDG_DATA_HOME`:

```nix
xdg.dataFile = {
  "my-app/data.json".text = builtins.toJSON { key = "value"; };
};
```

## Activation Scripts

Run scripts when the Home Manager generation activates:

```nix
home.activation = {
  myScript = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # runs after files are written
    ${pkgs.git}/bin/git config --global core.editor "nvim"
  '';
};
```

## Standalone vs NixOS Module

### Standalone

```bash
home-manager build --flake .#user@hostname --no-out-link
home-manager switch --flake .#user@hostname
```

Flake output:

```nix
homeConfigurations."user@hostname" = home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [ ./home.nix ];
};
```

### As NixOS Module

```nix
# In flake.nix modules list
home-manager.nixosModules.home-manager
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.username = import ./home.nix;
  home-manager.extraSpecialArgs = { inherit self; };
}
```

Key differences:
- **Standalone**: separate build command, separate generation, can be used on non-NixOS
- **NixOS module**: built as part of `nixos-rebuild`, shares pkgs with system, NixOS only

## Custom Module Pattern

```nix
{ config, lib, pkgs, ... }:

let
  cfg = config.my.programs.myTool;
in
{
  options.my.programs.myTool = {
    enable = lib.mkEnableOption "myTool";

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Settings for myTool.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.myTool ];
    xdg.configFile."myTool/config.json".text = builtins.toJSON cfg.settings;
  };
}
```

## Session Variables

```nix
home.sessionVariables = {
  EDITOR = "nvim";
  PAGER = "less";
};

home.sessionPath = [
  "$HOME/.local/bin"
];
```
