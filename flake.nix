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
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-services = {
      url = "github:homebrew/homebrew-services";
      flake = false;
    };
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";

  };

  outputs = { nixpkgs, nix-darwin, home-manager, nix-homebrew, alacritty-theme
    , zjstatus, ... }: {

      darwinConfigurations."mcbp" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { wm = "yabai"; };
        modules = [
          ./modules/darwin
          {
            nixpkgs.config.allowUnfree = true;
            nix.settings.experimental-features = "nix-command flakes";
            system.stateVersion = 5;
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
              enable = true;
              enableRosetta = true;
              user = "jakubcermak";
              autoMigrate = true;
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { wm = "yabai"; };
              sharedModules = [{
                home.username = "jakubcermak";
                home.homeDirectory = "/Users/jakubcermak";
              }];
              users.jakubcermak = { ... }: {

                imports = [ ./modules/darwin/home.nix ];
              };
            };
          }
        ];
      };

      darwinConfigurations."mcbp-work" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { wm = "aerospace"; };
        modules = [
          ./modules/darwin
          {
            nixpkgs.config.allowUnfree = true;
            nix.settings.experimental-features = "nix-command flakes";
            system.stateVersion = 5;
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
              enable = true;
              enableRosetta = true;
              user = "jakubcermak";
              autoMigrate = true;
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { wm = "aerospace"; };
              sharedModules = [{
                home.username = "jakubcermak";
                home.homeDirectory = "/Users/jakubcermak";
              }];
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
              sharedModules = [{
                home.username = "jakubcermak";
                home.homeDirectory = "/home/jakubcermak";
              }];
              users.jakubcermak = import ./modules/nixos/home.nix;
            };
          }
        ];
      };
    };
}
