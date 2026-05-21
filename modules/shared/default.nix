{
  pkgs,
  config,
  lib,
  inputs,
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
      heliumPackage =
        if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then
          inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
        else
          pkgs.writeShellApplication {
            name = "helium";
            text = ''
              for candidate in /usr/bin/helium /usr/local/bin/helium; do
                if [ -x "$candidate" ]; then
                  exec "$candidate" "$@"
                fi
              done

              if command -v flatpak >/dev/null 2>&1; then
                for app_id in net.imput.Helium org.imput.Helium io.github.imputnet.helium; do
                  if flatpak info "$app_id" >/dev/null 2>&1; then
                    exec flatpak run "$app_id" "$@"
                  fi
                done
              fi

              echo "Helium is not available as a native ${pkgs.stdenv.hostPlatform.system} package." >&2
              echo "Install a native Helium package or Flatpak, then this launcher will delegate to it." >&2
              exit 127
            '';
          };
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
        ++ lib.optionals pkgs.stdenv.isLinux [
          heliumPackage
        ]
      );

      sessionVariables = {
        EDITOR = lib.mkForce "zed";
        VISUAL = lib.mkForce "zed";
        TERMINAL = "ghostty";
        BROWSER = "helium";
      };

    };

  xdg.mimeApps = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    defaultApplications =
      let
        browser = [ "helium.desktop" ];
        editor = [ "dev.zed.Zed.desktop" ];
      in
      {
        "text/html" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/unknown" = browser;
        "text/plain" = editor;
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      };
  };

  xdg.desktopEntries = lib.mkIf pkgs.stdenv.isLinux {
    helium = {
      name = "Helium";
      genericName = "Web Browser";
      exec = "helium %U";
      terminal = false;
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeType = [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
    };
  };
}
