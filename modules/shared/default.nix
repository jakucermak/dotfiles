{ config, pkgs, lib, inputs, system, ... }: {
  imports = [ ./editors ./shells ./terminals ];

  programs.home-manager.enable = true;

  home = {
    username = "jakubcermak";
    homeDirectory = if pkgs.stdenv.isDarwin then
      "/Users/jakubcermak"
    else
      "/home/jakubcermak";

    packages = with pkgs; [
      qemu
      ansible-lint
      bottom
      curl
      fzf
      git
      nil
      nixd
      nixfmt-classic
      python312
      python312Packages.ansible-core
      ripgrep-all
      rustup
      tree
      zoxide
      bat
      lsd
    ];

    # Fix the file paths to use absolute paths
    file = {
      ".config/zed/themes".source = ./zed/themes;
      ".config/zed/settings.json".source = ./zed/settings.json;
      ".config/zed/keymap.json".source = ./zed/keymap.json;
    };

    sessionVariables = { EDITOR = "nvim"; };

    stateVersion = "24.11";
  };
}
