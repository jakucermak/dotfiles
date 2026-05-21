{ pkgs, lib, ... }:
{
  home.packages = builtins.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) (
    with pkgs;
    [
      hyprland
      hyprpaper
      hypridle
      hyprlock
      waybar
      walker
      wl-clipboard
      grim
      slurp
      swappy
      brightnessctl
      pamixer
      playerctl
      networkmanagerapplet
      nautilus
      xdg-desktop-portal-hyprland
      xdg-utils
    ]
  );
}
