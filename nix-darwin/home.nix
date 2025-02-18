{ config, pkgs, lib, inputs, ... }: {
  imports = [
    ./shells/zshell.nix
    ./shells/fish.nix
    ./shells/starship.nix
    ./terminals/tmux.nix
    ./terminals/alacritty.nix
    ./terminals/ghostty.nix
    (import ./terminals/zellij.nix {
      inherit pkgs;
      config = config;
      zjstatus = inputs.zjstatus.packages.${pkgs.system}.default;
    })
    # ./editors/nvim.nix
    ./aerospace.nix
  ];

  home.username = "jakubcermak";
  home.homeDirectory = "/Users/jakubcermak";
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    ansible-lint
    bottom
    curl
    fzf
    git
    nil
    nixd
    nixfmt-classic
    ntfs3g
    python312
    python312Packages.ansible-core
    ripgrep-all
    rustup
    tree
    zoxide
    bat
    lsd
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = let
    dotfiles =
      config.lib.file.mkOutOfStoreSymlink "/Users/jakubcermak/dotfiles";
  in {
    ".config/sketchybar".source = "${dotfiles}/sketchybar";
    ".config/zed/themes".source = "${dotfiles}/zed/themes";
    ".config/zed/settings.json".source = "${dotfiles}/zed/settings.json";
    ".config/zed/keymap.json".source = "${dotfiles}/zed/keymap.json";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
