# Flake Patterns Reference

## Basic Flake Structure

```nix
{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    # outputs here
  };
}
```

## Common Input Patterns

```nix
inputs = {
  # Nixpkgs — pick a branch
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

  # Home Manager — match nixpkgs branch
  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # flake-utils
  flake-utils.url = "github:numtide/flake-utils";

  # flake-parts (alternative to flake-utils)
  flake-parts.url = "github:hercules-ci/flake-parts";

  # nix-darwin
  darwin = {
    url = "github:LnL7/nix-darwin";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Custom flake from private registry
  my-flake = {
    url = "git+ssh://git@github.com/user/repo";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Non-flake source
  some-source = {
    url = "github:user/repo";
    flake = false;
  };
};
```

## Output Structure

```nix
outputs = { self, nixpkgs, home-manager, ... }:
let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in {
  # NixOS configurations
  nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      ./hosts/hostname/configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.username = import ./home/default.nix;
      }
    ];
  };

  # Standalone Home Manager configurations
  homeConfigurations."user@hostname" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [ ./home/default.nix ];
    extraSpecialArgs = { inherit self; };
  };

  # Development shells
  devShells.${system}.default = pkgs.mkShell {
    packages = with pkgs; [ nil nixfmt-rfc-style ];
  };

  # Packages
  packages.${system}.default = pkgs.callPackage ./package.nix {};

  # Overlays
  overlays.default = final: prev: {
    my-package = final.callPackage ./package.nix {};
  };
};
```

## Overlay Patterns

```nix
# Define an overlay
overlays.default = final: prev: {
  # Add a new package
  my-tool = final.callPackage ./pkgs/my-tool {};

  # Override an existing package
  htop = prev.htop.overrideAttrs (old: {
    patches = (old.patches or []) ++ [ ./htop-custom.patch ];
  });
};

# Apply overlays in a NixOS config
nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
  modules = [
    ({ pkgs, ... }: {
      nixpkgs.overlays = [
        self.overlays.default
        other-flake.overlays.default
      ];
    })
    ./configuration.nix
  ];
};
```

## Input Follows / Overrides

```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  # Force home-manager to use our nixpkgs
  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Force a transitive dependency
  some-flake = {
    url = "github:user/repo";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };
};
```

## Lock Management

```bash
# Update all inputs
nix flake update

# Update a single input
nix flake update nixpkgs

# Show current lock info
nix flake metadata

# Override an input temporarily
nix build --override-input nixpkgs path:/local/nixpkgs
```

## Passing Extra Arguments to Modules

```nix
# Using specialArgs (available in all modules)
nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
  specialArgs = { inherit self; custom-var = "value"; };
  modules = [ ./configuration.nix ];
};

# Using extraSpecialArgs (Home Manager standalone)
homeConfigurations."user@host" = home-manager.lib.homeManagerConfiguration {
  extraSpecialArgs = { inherit self; };
  modules = [ ./home.nix ];
};

# In the receiving module
{ self, custom-var, config, pkgs, lib, ... }:
{
  # can use self, custom-var here
}
```

## Multi-System Patterns

```nix
# Using flake-utils
outputs = { self, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages.${system}; in
    {
      packages.default = pkgs.callPackage ./package.nix {};
      devShells.default = pkgs.mkShell { packages = [ pkgs.nil ]; };
    }
  ) // {
    # Non-per-system outputs (NixOS configs, overlays, etc.)
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem { ... };
  };
```
