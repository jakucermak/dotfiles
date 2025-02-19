{ config, pkgs, lib, inputs, system, ... }: {
  imports = [
    ./fish.nix ./zshell.nix ./starship.nix
  ];
}
