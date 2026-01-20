{ pkgs, config, ... }: {

  programs.home-manager.enable = true;

  imports = [ ./terminals ./shells ./editors ];

  home = let dotfiles = "${config.home.homeDirectory}/dotfiles/";
  in {
    packages = with pkgs; [
      qemu
      bottom
      curl
      fzf
      git
      nil
      nixd
      nixfmt
      python313
      ripgrep-all
      rustup
      tree
      zoxide
      bat
      lsd
      btop
      age
      socat
      ansible-lint
      ansible
    ];

    file = {
      ".config/zed/themes" = {
        source = config.lib.file.mkOutOfStoreSymlink
          "${dotfiles}/modules/shared/zed/themes";
        recursive = true;
      };
      ".config/zed/settings.json" = {
        source = config.lib.file.mkOutOfStoreSymlink
          "${dotfiles}/modules/shared/zed/settings.json";
      };
      ".config/zed/keymap.json" = {
        source = config.lib.file.mkOutOfStoreSymlink
          "${dotfiles}/modules/shared/zed/keymap.json";
      };
    };
    sessionVariables = { EDITOR = "nvim"; };

  };
}
