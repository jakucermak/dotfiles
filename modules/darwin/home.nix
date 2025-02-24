{ wm, pkgs, lib, ... }: {

  imports = [
    # home pkgs
    ../shared
    ./sketchybar
  ] ++ (if wm == "yabai" then [
    ./yabai.nix
    ./skhd.nix
  ] else
    [ ./aerospace.nix ]);

  home = {

    # inherit wm;
    stateVersion = "24.11";
    homeDirectory = lib.mkForce "/Users/jakubcermak";

    packages = with pkgs; [ ntfs3g ];

    activation.printWM = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "Home Manager: WM is set to ${wm}"
    '';

  };
}
