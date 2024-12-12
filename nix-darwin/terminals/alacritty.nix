{ config, lib, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      env = { TERM = "xterm-256color"; };

      window = {
        decorations = "Transparent";
        dynamic_padding = false;
        opacity = 0.9;
        blur = true;
        option_as_alt = "OnlyRight";
        padding = {
          x = 15;
          y = 40;
        };
      };

      font = {
        size = 15.0;
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Heavy";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Heavy Italic";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Medium Italic";
        };
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Medium";
        };
      };

      terminal = {
        shell = {
          program = "${pkgs.tmux}/bin/tmux";
          args = [ "new-session" "-A" "-s" "main" ];
        };
      };
      # For the theme, you'll need to ensure the theme file is available
      # You might want to add this to your home.file entries or use import_yaml
      general = { import = [ pkgs.alacritty-theme.ayu_dark ]; };
    };
  };
}
