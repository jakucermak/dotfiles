{
  description = "Jakub Darwin system flake";

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

  outputs = inputs@{ self, nix-darwin, nix-homebrew, home-manager, nixpkgs
    , alacritty-theme, ... }:
    let
      sharedConfiguration = { pkgs, ... }: {
        nixpkgs.config.allowUnfree = true;
        environment.systemPackages = [ pkgs.home-manager pkgs.slack ];
        fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
        nix.settings.experimental-features = "nix-command flakes";
        programs.zsh.enable = true;
        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 5;
        users.users.jakubcermak.home = "/Users/jakubcermak";
      };

      darwinConfiguration = { pkgs, ... }: {
        imports = [ sharedConfiguration ];
        environment.systemPackages = [ pkgs.raycast ];

        homebrew = {
          enable = true;
          onActivation.cleanup = "uninstall";
          brews = [
            "mas"
            "telnet"
            "nmap"
            "lua"
            "switchaudio-osx"
            "nowplaying-cli"
            {
              name = "FelixKratz/formulae/sketchybar";
              start_service = false;
            }
            { name = "surrealdb/tap/surreal"; }
            { name = "jesseduffield/lazygit/lazygit"; }
          ];
          casks = [
            "zen-browser"
            "ghostty"
            "zed@preview"
            "chatgpt"
            "openvpn-connect"
            "vnc-viewer"
            "sf-symbols"
            "font-sf-mono"
            "font-sf-pro"
            "twingate"
          ];
          masApps = {
            "Spark" = 6445813049;
            "WireGuard" = 1451685025;
          };
        };

        security.pam.enableSudoTouchIdAuth = true;

        system.defaults = {
          dock = {
            autohide = true;
            show-recents = false;
            minimize-to-application = true;
            expose-group-apps = true;
            persistent-apps = [
              "/Applications/SigmaOS.app"
              "/Applications/Safari.app"
              "${pkgs.slack}/Applications/Slack.app"
              "/System/Applications/Messages.app"
              "${pkgs.alacritty}/Applications/Alacritty.app"
              "/Applications/Zed Preview.app"
            ];
            persistent-others =
              [ "/Users/jakubcermak/Downloads" "/Applications" ];
            mru-spaces = false;
          };
          finder = {
            AppleShowAllExtensions = true;
            FXPreferredViewStyle = "clmv";
          };
          loginwindow.LoginwindowText = "jakucermak-toolbox";
          screencapture.location = "~/Pictures/screenshots";
          screensaver.askForPasswordDelay = 10;
          NSGlobalDomain._HIHideMenuBar = true;
          NSGlobalDomain.ApplePressAndHoldEnabled = false;
          spaces.spans-displays = true;
        };
        nixpkgs.hostPlatform = "aarch64-darwin";
      };

      linuxConfiguration = { ... }: {
        imports = [ sharedConfiguration ];
        nixpkgs.hostPlatform = "aarch64-linux";
      };

    in {
      # Build darwin flake using:
      darwinConfigurations."book-pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          darwinConfiguration
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
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jakubcermak = { ... }: {
              imports = [ ./home.nix ];
              _module.args.inputs = inputs;
            };
          }
        ];
      };

      nixosConfigurations."linux-vm" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          linuxConfiguration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jakubcermak = { ... }: {
              imports = [ ./home.nix ];
              _module.args.inputs = inputs;
            };
          }
        ];
      };
    };
}
