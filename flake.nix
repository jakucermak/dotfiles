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
    zjstatus.url = "github:dj95/zjstatus";
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

    # homebrew-FelixKratz-formulae = {
    #   url = "github:FelixKratz/homebrew-formulae";
    #   flake = false;
    # };
    # homebrew-jesseduffield-formulae = {
    #   url = "github:jesseduffield/homebrew-formulae";
    #   flake = false;
    # };

    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
    tmux-sessionx.url = "github:omerxx/tmux-sessionx";
  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      homebrew-bundle,
      alacritty-theme,
      zjstatus,
      ...
    }:
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
              (final: prev: {
                zjstatus = zjstatus.packages.${prev.system}.default;
              })
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
          {
            home-manager = {
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
          # nix-homebrew.darwinModules.nix-homebrew
          # {
          #   nixpkgs.overlays = [
          #     alacritty-theme.overlays.default
          #     (final: prev: {
          #       zjstatus = zjstatus.packages.${prev.system}.default;
          #     })
          #   ];
          #   nix-homebrew = {
          #     enable = true;
          #     enableRosetta = true;
          #     user = "jakubcermak";
          #     autoMigrate = true;
          #   };
          # }
          home-manager.darwinModules.home-manager
          {
            home-manager = {
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
    };
}
