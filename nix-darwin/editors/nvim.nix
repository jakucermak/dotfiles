{ pkgs, ... }: {

  home.sessionVariables = { EDITOR = "nvim"; };
  xdg.configFile.nvim.source = ./nvim;

  programs.neovim = {
    defaultEditor = true;
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [ lua-language-server stylua ripgrep ];

  };

}
