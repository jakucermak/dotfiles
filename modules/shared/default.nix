{ pkgs, config, ... }:
{

  programs.home-manager.enable = true;

  imports = [
    ./terminals
    ./shells
    ./editors
  ];

  home =
    let
      dotfiles = "${config.home.homeDirectory}/dotfiles/";
    in
    {
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
        fd
      ];

      sessionVariables = {
        EDITOR = "nvim";
      };

    };
}
