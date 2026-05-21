{
  pkgs,
  config,
  lib,
  ...
}:
{

  programs.home-manager.enable = true;

  imports = [
    ./terminals
    ./shells
    ./editors
    ./terminal_tools
  ];

  home =
    let
      dotfiles = "${config.home.homeDirectory}/dotfiles/";
      ghosttyPackage =
        if pkgs.stdenv.isLinux then
          pkgs.writeShellApplication {
            name = "ghostty";
            text = ''
              export GBM_BACKENDS_PATH=${pkgs.mesa}/lib/gbm
              export LIBGL_DRIVERS_PATH=${pkgs.mesa}/lib/dri
              export LIBVA_DRIVERS_PATH=${pkgs.mesa}/lib/dri
              export __EGL_VENDOR_LIBRARY_FILENAMES=${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json
              export LD_LIBRARY_PATH=${lib.makeLibraryPath [
                pkgs.mesa
                pkgs.libglvnd
                pkgs.zlib
                pkgs.libdrm
              ]}''${LD_LIBRARY_PATH:+:''${LD_LIBRARY_PATH}}
              export LIBGL_ALWAYS_SOFTWARE=1

              exec ${lib.getExe pkgs.ghostty} "$@"
            '';
          }
        else
          pkgs.ghostty;
    in
    {
      packages = builtins.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) (
        with pkgs;
        [

          twingate
          codex
          chatgpt
          zed
          ghosttyPackage
          qemu
          bottom
          curl
          fzf
          git
          glab
          nil
          nixd
          nixfmt
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
          uv
          nmap
          lua
          sublime-merge
          virt-manager
        ]
      );

      sessionVariables = {
        EDITOR = "nvim";
      };

    };
}
