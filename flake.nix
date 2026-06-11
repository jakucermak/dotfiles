{
  description = "Jakub Dev system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-system-graphics = {
      url = "github:soupglasses/nix-system-graphics";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
    tmux-sessionx.url = "github:omerxx/tmux-sessionx";
  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      home-manager,
      system-manager,
      nix-system-graphics,
      nix-homebrew,
      alacritty-theme,
      ...
    }:
    let
      fedoraArm64System = "aarch64-linux";
      fedoraArm64Pkgs = import nixpkgs {
        system = fedoraArm64System;
        config.allowUnfree = true;
      };
      mkHomeManagerBackupCommand =
        pkgs:
        pkgs.writeShellScript "home-manager-backup" ''
          set -euo pipefail

          target="$1"
          stamp="$(${pkgs.coreutils}/bin/date +%Y%m%d%H%M%S)"
          backup="$target.backup-$stamp"
          i=0

          while [[ -e "$backup" ]]; do
            i=$((i + 1))
            backup="$target.backup-$stamp-$i"
          done

          ${pkgs.coreutils}/bin/mv -- "$target" "$backup"
        '';
    in
    {

      darwinConfigurations."mcbp" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          wm = "yabai";
          inherit inputs;
        };
        modules = [
          ./modules/darwin
          {
            nixpkgs.config.allowUnfree = true;
            nix.settings.experimental-features = "nix-command flakes";
            system.stateVersion = 6;
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nixpkgs.overlays = [
              alacritty-theme.overlays.default
            ];
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "jakubcermak";
              autoMigrate = true;
            };
          }
          home-manager.darwinModules.home-manager
          (
            { pkgs, ... }:
            {
              home-manager = {
                backupCommand = "${mkHomeManagerBackupCommand pkgs}";
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  wm = "yabai";
                  inherit inputs;
                };
                sharedModules = [
                  {
                    home.username = "jakubcermak";
                    home.homeDirectory = "/Users/jakubcermak";
                  }
                ];
                users.jakubcermak =
                  { ... }:
                  {
                    imports = [ ./modules/darwin/home.nix ];
                  };
              };
            }
          )
        ];
      };

      darwinConfigurations."mcbp-work" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          wm = "aerospace";
          inherit inputs;
        };
        modules = [
          ./modules/darwin
          {
            nixpkgs.config.allowUnfree = true;
            nix.settings.experimental-features = "nix-command flakes";
            system.stateVersion = 5;
          }

          home-manager.darwinModules.home-manager
          (
            { pkgs, ... }:
            {
              home-manager = {
                backupCommand = "${mkHomeManagerBackupCommand pkgs}";
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  wm = "aerospace";
                  inherit inputs;
                };
                sharedModules = [
                  {
                    home.username = "jakubcermak";
                    home.homeDirectory = "/Users/jakubcermak";
                  }
                ];
                users.jakubcermak = import ./modules/darwin/home.nix;
              };
            }
          )
        ];
      };

      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/nixos
          {
            nixpkgs.config.allowUnfree = true;
            nix.settings.experimental-features = "nix-command flakes";
            system.stateVersion = "23.11";
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              sharedModules = [
                {
                  home.username = "jakubcermak";
                  home.homeDirectory = "/home/jakubcermak";
                }
              ];
              users.jakubcermak = import ./modules/nixos/home.nix;
            };
          }
        ];
      };

      homeConfigurations."fedora-arm64" = home-manager.lib.homeManagerConfiguration {
        pkgs = fedoraArm64Pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./modules/linux
          {
            home = {
              username = "jcermak";
              homeDirectory = "/home/jcermak";
              stateVersion = "23.11";
            };
          }
        ];
      };

      systemConfigs."fedora-arm64" = system-manager.lib.makeSystemConfig {
        modules = [
          nix-system-graphics.systemModules.default
          {
            nixpkgs.hostPlatform = fedoraArm64System;
            system-manager.allowAnyDistro = true;
            system-graphics.enable = true;
          }
        ];
      };
    };
}
