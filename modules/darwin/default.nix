{ pkgs, wm, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [ pkgs.home-manager ];

  homebrew = {
    enable = true;
    # onActivation.cleanup = "uninstall";
    brews = [
      "node"
      "mas"
      "telnet"
      "switchaudio-osx"
      "nowplaying-cli"
      "pyenv"
      "dpkg"
      { name = "FelixKratz/formulae/sketchybar"; }
      { name = "jesseduffield/lazygit/lazygit"; }
    ];
    casks = [
      "zed@preview"
      "vnc-viewer"
      "sf-symbols"
      "font-sf-mono"
      "font-sf-pro"
      "chromium"
      "macfuse"
      "hammerspoon"
    ];
  };

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  # services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh = {
    enable = true;
    enableBashCompletion = false;
    enableGlobalCompInit = false;
  };
  nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.services.sudo_local.touchIdAuth = true;
  users.users.jakubcermak.home = "/Users/jakubcermak";

  system = {
    stateVersion = 6;
    primaryUser = "jakubcermak";
    defaults = {
      dock = {
        autohide = true;
        show-recents = false;
        minimize-to-application = true;
        expose-group-apps = true;
        persistent-apps = [
          "/Applications/Safari.app"
          "/System/Applications/Messages.app"
          "/Applications/Ghostty.app"
          "/Applications/Zed Preview.app"
        ];
        persistent-others = [
          "/Users/jakubcermak/Downloads"
          "/Applications"
        ];
        mru-spaces = true;
      };
      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "clmv";
      };
      loginwindow.LoginwindowText = "jakucermak-toolbox";
      screencapture.location = "~/Pictures/screenshots";
      screensaver.askForPasswordDelay = 10;
      NSGlobalDomain = {
        _HIHideMenuBar = true;
        ApplePressAndHoldEnabled = false;
      };

      # If WM is changed to Aerospace = true, Yabai = false
      spaces.spans-displays = if wm == "yabai" then false else true;
    };
  };
}
