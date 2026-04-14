{ pkgs, ... }: {

  programs.neovim = {
    defaultEditor = true;
    enable = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;

    extraPackages = with pkgs; [ lua-language-server stylua ripgrep ];

  };

}
