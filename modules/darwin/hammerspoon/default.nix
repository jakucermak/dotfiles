{ config, ... }:
{

  home.file.".hammerspoon" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/darwin/hammerspoon/config";
    recursive = true;
  };
}
