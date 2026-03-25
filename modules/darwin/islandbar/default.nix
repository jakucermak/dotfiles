{ config, ... }: {

  home.file.".config/sketchybar" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/modules/darwin/islandbar/config";
    recursive = true;
  };

}
