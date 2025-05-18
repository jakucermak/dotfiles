{ pkgs, wm, ... }:

{

  nixpkgs.config.allowUnfree = true;
  imports = [ ./borders ];

  # List packages installed in system profile. To search by name, run:
  environment.systemPackages = [ pkgs.home-manager pkgs.raycast pkgs.slack ];

  homebrew = {
    enable = true;
    # onActivation.cleanup = "uninstall";
    brews = [
      "node"
      "superfile"
      "mas"
      "telnet"
      "nmap"
      "lua"
      "switchaudio-osx"
      "nowplaying-cli"
      "pyenv"
      "dpkg"
      "ansible@9"
      { name = "FelixKratz/formulae/sketchybar"; }
      { name = "jesseduffield/lazygit/lazygit"; }
    ];
    casks = [
      "warp"
      "sublime-merge"
      "ghostty"
      "zed@preview"
      "chatgpt"
      "vnc-viewer"
      "sf-symbols"
      "font-sf-mono"
      "font-sf-pro"
      "twingate"
      "chromium"
    ];
    masApps = {
      # "Spark" = 6445813049;
      # "WireGurad" = 1451685025;
    };
  };

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  # services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
  system.stateVersion = 5;
  nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.services.sudo_local.touchIdAuth = true;
  users.users.jakubcermak.home = "/Users/jakubcermak";
  system.primaryUser = "jakubcermak";

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
        "/Applications/Ghostty.app"
        "/Applications/Zed Preview.app"
      ];
      persistent-others = [ "/Users/jakubcermak/Downloads" "/Applications" ];
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

    # If WM is changed to Aerospace = true, Yabai = false
    spaces.spans-displays = if wm == "yabai" then false else true;

  };
}
