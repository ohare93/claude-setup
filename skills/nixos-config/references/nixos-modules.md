# NixOS Modules Reference

## Module Structure

A NixOS module is a function that returns an attrset with `options` and/or `config`:

```nix
{ config, lib, pkgs, ... }:

let
  cfg = config.services.myService;
in
{
  options.services.myService = {
    enable = lib.mkEnableOption "my service";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port to listen on.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.myService;
      description = "Package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.myService = {
      description = "My Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/my-service --port ${toString cfg.port}";
        DynamicUser = true;
        Restart = "on-failure";
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
```

## Option Declarations

### Common Option Types

```nix
lib.types.bool
lib.types.int
lib.types.str
lib.types.path
lib.types.port              # integer 0-65535
lib.types.package
lib.types.lines             # multi-line string
lib.types.attrs             # untyped attrset
lib.types.anything          # any type

# Compound types
lib.types.listOf lib.types.str
lib.types.attrsOf lib.types.str
lib.types.nullOr lib.types.str
lib.types.either lib.types.str lib.types.int
lib.types.enum [ "a" "b" "c" ]
lib.types.submodule { options = { ... }; }

# One of several types
lib.types.oneOf [ lib.types.str lib.types.int ]
```

### mkOption

```nix
lib.mkOption {
  type = lib.types.str;
  default = "value";
  example = "other-value";
  description = "What this option does.";
}
```

### mkEnableOption

```nix
# Shorthand for a boolean option defaulting to false
lib.mkEnableOption "my feature"

# Equivalent to:
lib.mkOption {
  type = lib.types.bool;
  default = false;
  description = "Whether to enable my feature.";
}
```

### Submodules

```nix
options.services.myService.sites = lib.mkOption {
  type = lib.types.attrsOf (lib.types.submodule {
    options = {
      domain = lib.mkOption {
        type = lib.types.str;
        description = "Domain name.";
      };
      root = lib.mkOption {
        type = lib.types.path;
        description = "Document root.";
      };
    };
  });
  default = {};
  description = "Sites to configure.";
};
```

## Config Patterns

### mkIf

```nix
config = lib.mkIf cfg.enable {
  # only applied when cfg.enable is true
};
```

### mkMerge

```nix
config = lib.mkMerge [
  (lib.mkIf cfg.enable {
    services.nginx.enable = true;
  })
  (lib.mkIf cfg.enableSSL {
    security.acme.acceptTerms = true;
  })
];
```

### mkDefault and mkForce

```nix
# mkDefault — priority 1000 (can be overridden by normal values)
services.nginx.enable = lib.mkDefault true;

# mkForce — priority 50 (overrides almost everything)
services.nginx.enable = lib.mkForce true;

# Normal value — priority 100
services.nginx.enable = true;
```

### mkOrder / mkBefore / mkAfter

```nix
# For list-type options, control ordering
environment.systemPackages = lib.mkBefore [ pkgs.git ];  # prepend
environment.systemPackages = lib.mkAfter [ pkgs.vim ];   # append
```

## Systemd Service Patterns

### Simple Service

```nix
systemd.services.my-app = {
  description = "My Application";
  wantedBy = [ "multi-user.target" ];
  after = [ "network.target" ];
  serviceConfig = {
    ExecStart = "${pkgs.my-app}/bin/my-app";
    DynamicUser = true;
    StateDirectory = "my-app";
    Restart = "on-failure";
    RestartSec = 5;
  };
};
```

### Service with Environment File

```nix
systemd.services.my-app = {
  serviceConfig = {
    ExecStart = "${pkgs.my-app}/bin/my-app";
    EnvironmentFile = config.age.secrets.my-app-env.path;
  };
};
```

### Timer (Cron Replacement)

```nix
systemd.timers.my-task = {
  wantedBy = [ "timers.target" ];
  timerConfig = {
    OnCalendar = "daily";
    Persistent = true;
  };
};

systemd.services.my-task = {
  serviceConfig = {
    Type = "oneshot";
    ExecStart = "${pkgs.my-script}/bin/run";
  };
};
```

## Package Patterns

### Override Package Inputs

```nix
pkgs.my-package.override {
  enableFeature = true;
  python3 = pkgs.python311;
}
```

### Override Derivation Attributes

```nix
pkgs.my-package.overrideAttrs (old: {
  patches = (old.patches or []) ++ [ ./fix.patch ];
  buildInputs = (old.buildInputs or []) ++ [ pkgs.extra-lib ];
})
```

### Build a Package from Source

```nix
pkgs.stdenv.mkDerivation {
  pname = "my-tool";
  version = "1.0.0";
  src = ./src;
  buildInputs = [ pkgs.openssl ];
  installPhase = ''
    mkdir -p $out/bin
    cp my-tool $out/bin/
  '';
}
```

## Assertions

```nix
config = lib.mkIf cfg.enable {
  assertions = [
    {
      assertion = cfg.port > 1024;
      message = "myService.port must be greater than 1024 for unprivileged users.";
    }
  ];
};
```

## Imports

```nix
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./services/nginx.nix
    ./users.nix
  ];

  # rest of config
}
```
