{ config, pkgs, lib, ... }: {
  imports = [
    ./shells/zshell.nix
    ./terminals/tmux.nix
    ./terminals/alacritty.nix
    # ./terminals/zellij.nix
  ];

  home.username = "jakubcermak";
  home.homeDirectory = "/Users/jakubcermak";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  nixpkgs.config.allowUnfree = true;
  home.packages = [
    pkgs.git
    pkgs.starship
    pkgs.neovim
    pkgs.nixd
    pkgs.nixfmt-classic
    pkgs.nil
    pkgs.zellij

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = let
    dotfiles =
      config.lib.file.mkOutOfStoreSymlink "/Users/jakubcermak/dotfiles";
  in {

    # ".config/nvim".source = ~/dotfiles/nvim;
    ".config/aerospace".source = "${dotfiles}/aerospace";
    ".config/zed/themes".source = "${dotfiles}/zed/themes";
    ".config/zed/settings.json".source = "${dotfiles}/zed/settings.json";
    ".config/zed/keymap.json".source = "${dotfiles}/zed/keymap.json";
    ".config/sketchybar".source = "${dotfiles}/sketchybar";

  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
