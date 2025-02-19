{ config, pkgs, inputs, ... }: {
  imports = [ ../shared ];

  home = { homeDirectory = "/home/jakubcermak"; };
}
