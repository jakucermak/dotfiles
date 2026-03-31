{
  wm,
  pkgs,
  lib,
  ...
}:
{

  imports = [
    ../shared
    ./sketchybar
    ./hammerspoon
    # ./borders
  ]
  ++ (
    if wm == "yabai" then
      [
        ./yabai.nix
        ./skhd.nix
      ]
    else
      [ ./aerospace.nix ]
  );

  home = {

    stateVersion = "24.11";
    homeDirectory = lib.mkForce "/Users/jakubcermak";

    packages = with pkgs; [ ntfs3g ];

    activation.printWM = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "Home Manager: WM is set to ${wm}"
    '';

    sessionVariables = {
      SKHD_SCRIPTS_DIR = "~/.config/skhd_skripts";
    };

  };
}
