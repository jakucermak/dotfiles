{ config, pkgs, lib, inputs, system, ... }: {
  imports = [ ../shared ];

  # home = {
  #   homeDirectory = "/Users/jakubcermak";

  #   packages = with pkgs; [ ntfs3g ];

  #   file = let
  #     dotfiles =
  #       config.lib.file.mkOutOfStoreSymlink "/Users/jakubcermak/dotfiles";
  #   in { ".config/sketchybar".source = "${dotfiles}/sketchybar"; };
  # };
}
