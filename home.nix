{ lib, pkgs,... }: {
  home = {
    stateVersion = "24.11";
    homeDirectory = lib.mkForce "/Users/jakubcermak";
  };
  programs.home-manager.enable = true;

  # We can start adding basic packages here
  home.packages = with pkgs; [
    # Start with just a few essential packages
    git
    curl
    ripgrep
  ];
}
