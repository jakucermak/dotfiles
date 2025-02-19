{ config, pkgs, lib, ... }: {

  imports = [ ../shared ./aerospace.nix ];

  home = {

    stateVersion = "24.11";
    homeDirectory = lib.mkForce "/Users/jakubcermak";

    packages = with pkgs; [ ntfs3g aerospace jankyborders sketchybar ];

    file = let
      dotfiles = config.lib.file.mkOutOfStoreSymlink
        "/Users/jakubcermak/dotfiles/modules/darwin";
    in {
      ".config/sketchybar".source = "${dotfiles}/sketchybar";
      # ".config/borders".source = "${dotfiles}/borders";
    };

  };
}
