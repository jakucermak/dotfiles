{ pkgs, ... }: {

  home.packages = [ pkgs.yabai ];

  home.file.yabairc = {
    text = ''
      yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
      sudo yabai --load-sa

      yabai -m config external_bar all:20:0

      # Layout
      yabai -m config layout bsp
      yabai -m config window_animation_duration 0.1
      yabai -m config window_animation_easing "ease_out_circ"
      # Padding and gaps
      yabai -m config top_padding    20
      yabai -m config bottom_padding 20
      yabai -m config left_padding   20
      yabai -m config right_padding  20
      yabai -m config window_gap     20

      # Mouse support
      yabai -m config mouse_modifier ctrl
      yabai -m config mouse_action1 move
      yabai -m config mouse_action2 resize

      yabai -m config mouse_follows_focus on
      yabai -m config focus_follows_mouse autofocus

      yabai -m rule --add app="^SigmaOS|Safari|Chromium$" space=1
      yabai -m rule --add app="^Finder" space=1

      yabai -m rule --add app="^Zed Preview$" space=2
      yabai -m rule --add app="^Xcode$" space=2

      yabai -m rule --add app="Alacritty" space=3
      yabai -m rule --add app="Ghostty" space=3

      yabai -m rule --add app="^Slack|Messages|ChatGPT$" space=4

      yabai -m rule --add app="^Spark Desktop" space=5

      yabai -m rule --add app="Music" space=6

      yabai -m rule --add app="^System Settings$" manage=off

    '';
    executable = true;
    target = ".yabairc";

  };

  # home.activation = {
  #   yabaiScript = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #         echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
  #       '';
  #     };
}
