{ config, pkgs, lib, ... }: {
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      external_bar = "all:0:0";
      layout = "bsp";
      auto_balance = "on";
      window_shadow = "off";
      window_animation_duration = 0.1;
      window_animation_easing = "ease_out_circ";

      mouse_modifier = "alt";
      # set modifier + right-click drag to resize window (default: resize)
      mouse_action2 = "resize";
      # set modifier + left-click drag to resize window (default: move)
      mouse_action1 = "move";

      mouse_follows_focus = "off";
      focus_follows_mouse = "autofocus";

      # gaps
      top_padding = 15;
      bottom_padding = 15;
      left_padding = 15;
      right_padding = 15;
      window_gap = 15;

    };

    extraConfig = ''
      yabai -m rule --add app="^SigmaOS" space=1
      yabai -m rule --add app="^Finder" space=1

      yabai -m rule --add app="^Zed Preview$" space=2
      yabai -m rule --add app="^Xcode$" space=2

      yabai -m rule --add app="Alacritty" space=3
      yabai -m rule --add app="Ghostty" space=3

      yabai -m rule --add app="Slack" space=4
      yabai -m rule --add app="Messages" space=4
      yabai -m rule --add app="ChatGPT" space=4

      yabai -m rule --add app="Spark" space=5

      yabai -m rule --add app="Music" space=6
    '';

  };
}
