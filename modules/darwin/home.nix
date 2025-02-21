{ config, pkgs, lib, ... }: {

  imports = [
    # home pkgs
    ../shared
    ./aerospace.nix
    ./sketchybar
    ./yabai.nix
    ./skhd.nix
  ];

  home = {

    stateVersion = "24.11";
    homeDirectory = lib.mkForce "/Users/jakubcermak";

    packages = with pkgs; [ ntfs3g aerospace ];
  };
}
