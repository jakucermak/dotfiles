{ config, pkgs, ... }:
let
    dotfilesRepo = "git+https://github.com/jakucermak/dotfiles.git";
    dotfilesPath = "${home.homeDirectory}/dotfiles";  # Path where dotfiles will be placed

    # Fetch the dotfiles repository
    dotfiles = pkgs.fetchFromGitHub {
      owner = "jakucermak";  # Replace with your GitHub username
      repo = "dotfiles";       # Replace with your repository name
      rev = "main";            # Or use a specific commit hash or tag
      sha256 = "";          # The sha256 hash of the repository content (see next step)
    };

in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jakubcermak";
  home.homeDirectory = "/Users/jakubcermak";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    #
    pkgs.git

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {

    ".zshrc" = {
      source = "${dotfiles}/${dotfilesPath}/.zshrc";
    }
    # ".config/alacritty".source = /Users/jakubcermak/dotfiles/alacritty;
    # # ".config/starship".source = /Users/jakubcermak/dotfiles/starship;
    # ".config/nvim".source = /Users/jakubcermak/dotfiles/nvim;
    # ".config/nix".source = /Users/jakubcermak/dotfiles/nix;
    # ".config/nix-darwin".source = /Users/jakubcermak/dotfiles/nix-darwin;
    # ".config/tmux".source = /Users/jakubcermak/dotfiles/tmux;
    # ".config/aerospace".source = /Users/jakubcermak/dotfiles/aerospace;
    # ".config/sketchybar".source = /Users/jakubcermak/dotfiles/sketchybar;
    # ".config/zed".source = /Users/jakubcermak/dotfiles/zed;
  };


  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
