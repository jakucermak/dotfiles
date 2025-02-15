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

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager
    , homebrew-bundle, homebrew-core, homebrew-cask, homebrew-services
    , homebrew-FelixKratz-formulae, alacritty-theme, zjstatus, ... }:
    let
      inherit (self) outputs;
      mkHome = modules: pkgs:
        home-manager.lib.homeManagerConfiguration {
          inherit modules pkgs;
          extraSpecialArgs = { inherit inputs outputs; };
        };

      configuration = { pkgs, ... }: {

        nixpkgs.config.allowUnfree = true;

        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages =
          [ pkgs.home-manager pkgs.raycast pkgs.slack ];
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
            # {
            #   name = "FelixKratz/formulae/borders";
            #   start_service = true;
            # }
            # {
            #   name = "FelixKratz/formulae/sketchybar";
            #   start_service = true;
            # }
            { name = "surrealdb/tap/surreal"; }
            { name = "jesseduffield/lazygit/lazygit"; }

          ];
          casks = [
            "zen-browser"
            # "nikitabobko/tap/aerospace"
            "zed@preview"
            "chatgpt"
            "openvpn-connect"
            "vnc-viewer"
            "sf-symbols"
            "font-sf-mono"
            "font-sf-pro"
          ];
          masApps = {
            "Spark" = 6445813049;
            "WireGurad" = 1451685025;
          };
        };

        fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

        # services.nix-daemon.enable = true;
        nix.settings.experimental-features = "nix-command flakes";
        programs.zsh.enable = true; # default shell on catalina
        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 5;
        nixpkgs.hostPlatform = "aarch64-darwin";

        security.pam.enableSudoTouchIdAuth = true;
        users.users.jakubcermak.home = "/Users/jakubcermak";

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

      };
    in {
      # Build darwin flake using:
      darwinConfigurations."book-pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          configuration
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

    };
}
