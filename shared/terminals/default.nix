{ config, pkgs, lib, inputs, system, ... }: {
  imports = [ ./alacritty.nix ./ghostty.nix ./tmux.nix ./zellij.nix ];
}
