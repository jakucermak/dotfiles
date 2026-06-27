{ pkgs, ... }:
let
  tomlFormat = pkgs.formats.toml { };

  ctrlA = builtins.fromJSON ''"\\u0001"'';
  ctrlE = builtins.fromJSON ''"\\u0005"'';
  escB = builtins.fromJSON ''"\\u001bb"'';
  escF = builtins.fromJSON ''"\\u001bf"'';

  ayuDark = {
    primary = {
      background = "#10141C";
      foreground = "#BFBDB6";
    };
    cursor.cursor = "#E6B450";
    normal = {
      black = "#5A6673";
      red = "#E6495A";
      green = "#97C142";
      yellow = "#E89D37";
      blue = "#17ACF2";
      magenta = "#C385FE";
      cyan = "#84CEB5";
      white = "#FFFFFF";
    };
    bright = {
      black = "#5A6673";
      red = "#F07178";
      green = "#AAD94C";
      yellow = "#FFB454";
      blue = "#59C2FF";
      magenta = "#D2A6FF";
      cyan = "#95E6CB";
      white = "#FFFFFF";
    };
  };

  ayuLight = {
    primary = {
      background = "#FCFCFC";
      foreground = "#5C6166";
    };
    cursor.cursor = "#F29718";
    normal = {
      black = "#ADAEB1";
      red = "#F07171";
      green = "#86B300";
      yellow = "#EBA400";
      blue = "#22A4E6";
      magenta = "#A37ACC";
      cyan = "#4CBF99";
      white = "#ADAEB1";
    };
    bright = {
      black = "#939498";
      red = "#F07171";
      green = "#86B300";
      yellow = "#EBA400";
      blue = "#22A4E6";
      magenta = "#A37ACC";
      cyan = "#4CBF99";
      white = "#C5C5C8";
    };
  };
in
{
  programs.alacritty = {
    enable = true;
    package = null;
    settings = {
      general.import = [ "~/.config/alacritty/themes/ayu_dark.toml" ];

      env.TERM = "xterm-256color";

      window = {
        padding = {
          x = 10;
          y = 0;
        };
        dynamic_padding = true;
        decorations = "Buttonless";
        option_as_alt = "Both";
      };

      font = {
        size = 15;
        normal.family = "JetBrainsMono Nerd Font";

        # Closest Alacritty equivalent to Ghostty's adjust-cell-height = 20%.
        # This makes tmux/box-drawing cells less cramped without changing font size.
        offset.y = 4;
        glyph_offset.y = 2;
      };

      cursor.style.shape = "Block";
      mouse.hide_when_typing = true;

      keyboard.bindings = [
        {
          key = "Right";
          mods = "Command";
          chars = ctrlE;
        }
        {
          key = "Left";
          mods = "Command";
          chars = ctrlA;
        }
        {
          key = "Left";
          mods = "Alt";
          chars = escB;
        }
        {
          key = "Right";
          mods = "Alt";
          chars = escF;
        }
      ];
    };
  };

  xdg.configFile = {
    "alacritty/themes/ayu_dark.toml".source = tomlFormat.generate "alacritty-ayu-dark.toml" {
      colors = ayuDark;
    };
    "alacritty/themes/ayu_light.toml".source = tomlFormat.generate "alacritty-ayu-light.toml" {
      colors = ayuLight;
    };
  };
}
