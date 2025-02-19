{
  description = "Jakub Dev system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    zjstatus = { url = "github:dj95/zjstatus"; };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    homebrew-FelixKratz-formulae = {
      url = "github:FelixKratz/homebrew-formulae";
      flake = false;
    };
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, home-manager, nixpkgs, alacritty-theme, ... }:
      let
        sharedConfiguration = { pkgs, ... }: {
          nixpkgs.config.allowUnfree = true;
          environment.systemPackages = [ pkgs.home-manager pkgs.slack ];
          fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
          nix.settings.experimental-features = "nix-command flakes";
          programs.zsh.enable = true;
          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 5;
        };
      in {
        darwinConfigurations."book-pro" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            sharedConfiguration
            ./modules/darwin
            nix-homebrew.darwinModules.nix-homebrew
            {
              nixpkgs.overlays = [ alacritty-theme.overlays.default ];
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
                extraSpecialArgs = { inherit inputs; };
                users.jakubcermak = { ... }: {
                  imports = [ ./modules/shared ];
                  home.stateVersion = "24.11";
                };
              };
            }
          ];
        };
      nixosConfigurations."linux-vm" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; }; # Add this line
        modules = [
          sharedConfiguration
          ./modules/linux
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; }; # Add this line
              users.jakubcermak = { ... }: {
                imports = [ ./modules/shared ];
                home.stateVersion = "24.11";
              };
            };
          }
        ];
      };
    };
}
