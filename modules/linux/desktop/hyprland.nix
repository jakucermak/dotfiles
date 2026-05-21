{ pkgs, lib, ... }:
{
  home.packages = builtins.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) (
    with pkgs;
    [
      hyprland
      hyprpaper
      hypridle
      hyprlock
      waybar
      walker
      wl-clipboard
      grim
      slurp
      swappy
      brightnessctl
      pamixer
      playerctl
      networkmanagerapplet
      nautilus
      xdg-desktop-portal-hyprland
      xdg-utils
    ]
  );

  xdg.configFile."hypr/hyprland.conf".text = ''
    source = ~/.config/hypr/monitors.conf
    source = ~/.config/hypr/input.conf
    source = ~/.config/hypr/bindings.conf
    source = ~/.config/hypr/look.conf
    source = ~/.config/hypr/autostart.conf
    source = ~/.config/hypr/user.conf
  '';

  xdg.configFile."hypr/monitors.conf".text = ''
    monitor = , preferred, auto, 1
  '';

  xdg.configFile."hypr/input.conf".text = ''
    input {
      kb_layout = us
      follow_mouse = 1
      sensitivity = 0

      touchpad {
        natural_scroll = true
        tap-to-click = true
        drag_lock = true
      }
    }

    gestures {
      workspace_swipe = true
      workspace_swipe_fingers = 3
    }
  '';

  xdg.configFile."hypr/look.conf".text = ''
    general {
      gaps_in = 5
      gaps_out = 10
      border_size = 2
      col.active_border = rgba(7aa2f7ff)
      col.inactive_border = rgba(3b4261ff)
      layout = dwindle
      resize_on_border = true
    }

    decoration {
      rounding = 0
      active_opacity = 1
      inactive_opacity = 1

      shadow {
        enabled = false
      }

      blur {
        enabled = false
      }
    }

    animations {
      enabled = true
      bezier = easeOutQuint, 0.23, 1, 0.32, 1
      animation = windows, 1, 3, easeOutQuint
      animation = border, 1, 4, easeOutQuint
      animation = fade, 1, 3, easeOutQuint
      animation = workspaces, 1, 3, easeOutQuint
    }

    dwindle {
      pseudotile = true
      preserve_split = true
      smart_split = true
    }

    misc {
      disable_hyprland_logo = true
      disable_splash_rendering = true
      force_default_wallpaper = 0
      new_window_takes_over_fullscreen = 2
    }
  '';

  xdg.configFile."hypr/bindings.conf".text = ''
    $mainMod = SUPER
    $terminal = ghostty
    $browser = helium
    $editor = zeditor
    $launcher = walker

    bind = $mainMod, Return, exec, $terminal
    bind = $mainMod, B, exec, $browser
    bind = $mainMod, E, exec, $editor
    bind = $mainMod, Space, exec, $launcher
    bind = $mainMod, Q, killactive
    bind = $mainMod, F, fullscreen
    bind = $mainMod, V, togglefloating
    bind = $mainMod, P, pseudo
    bind = $mainMod, J, togglesplit
    bind = $mainMod SHIFT, E, exit

    bind = $mainMod, H, movefocus, l
    bind = $mainMod, L, movefocus, r
    bind = $mainMod, K, movefocus, u
    bind = $mainMod, J, movefocus, d

    bind = $mainMod SHIFT, H, movewindow, l
    bind = $mainMod SHIFT, L, movewindow, r
    bind = $mainMod SHIFT, K, movewindow, u
    bind = $mainMod SHIFT, J, movewindow, d

    bind = $mainMod CTRL, H, resizeactive, -80 0
    bind = $mainMod CTRL, L, resizeactive, 80 0
    bind = $mainMod CTRL, K, resizeactive, 0 -80
    bind = $mainMod CTRL, J, resizeactive, 0 80

    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    bind = , Print, exec, grim -g "$(slurp)" - | swappy -f -
    bind = $mainMod, Print, exec, grim - | swappy -f -

    bindel = , XF86AudioRaiseVolume, exec, pamixer -i 5
    bindel = , XF86AudioLowerVolume, exec, pamixer -d 5
    bindl = , XF86AudioMute, exec, pamixer -t
    bindl = , XF86AudioPlay, exec, playerctl play-pause
    bindl = , XF86AudioNext, exec, playerctl next
    bindl = , XF86AudioPrev, exec, playerctl previous
    bindel = , XF86MonBrightnessUp, exec, brightnessctl set 5%+
    bindel = , XF86MonBrightnessDown, exec, brightnessctl set 5%-

    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow
  '';

  xdg.configFile."hypr/autostart.conf".text = ''
    exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once = waybar
    exec-once = hyprpaper
    exec-once = hypridle
    exec-once = nm-applet --indicator
  '';

  xdg.configFile."hypr/user.conf".text = ''
    # Local machine overrides go here.
  '';

  xdg.configFile."uwsm/env".text = ''
    export XDG_CURRENT_DESKTOP=Hyprland
    export XDG_SESSION_DESKTOP=Hyprland
    export XDG_SESSION_TYPE=wayland
    export GDK_BACKEND=wayland,x11
    export QT_QPA_PLATFORM=wayland;xcb
    export SDL_VIDEODRIVER=wayland
    export CLUTTER_BACKEND=wayland
  '';

  xdg.configFile."waybar/config".text = ''
    {
      "layer": "top",
      "position": "top",
      "height": 30,
      "spacing": 8,
      "modules-left": ["hyprland/workspaces"],
      "modules-center": ["clock"],
      "modules-right": ["tray", "network", "pulseaudio", "battery"],
      "hyprland/workspaces": {
        "disable-scroll": true,
        "all-outputs": true,
        "format": "{name}"
      },
      "clock": {
        "format": "{:%a %d %b  %H:%M}",
        "tooltip-format": "{:%Y-%m-%d}"
      },
      "network": {
        "format-wifi": "{essid}",
        "format-ethernet": "wired",
        "format-disconnected": "offline",
        "tooltip-format": "{ifname}"
      },
      "pulseaudio": {
        "format": "{volume}%",
        "format-muted": "muted",
        "scroll-step": 5
      },
      "battery": {
        "format": "{capacity}%",
        "format-charging": "{capacity}% charging",
        "states": {
          "warning": 30,
          "critical": 15
        }
      },
      "tray": {
        "spacing": 8
      }
    }
  '';

  xdg.configFile."waybar/style.css".text = ''
    * {
      border: none;
      border-radius: 0;
      font-family: "JetBrainsMono Nerd Font", monospace;
      font-size: 12px;
      min-height: 0;
    }

    window#waybar {
      background: #11131a;
      color: #c0caf5;
      border-bottom: 1px solid #2f3549;
    }

    #workspaces button {
      color: #7aa2f7;
      padding: 0 10px;
      background: transparent;
    }

    #workspaces button.active {
      color: #11131a;
      background: #7aa2f7;
    }

    #clock,
    #network,
    #pulseaudio,
    #battery,
    #tray {
      padding: 0 10px;
    }

    #battery.warning {
      color: #e0af68;
    }

    #battery.critical {
      color: #f7768e;
    }
  '';

  xdg.configFile."walker/config.toml".text = ''
    terminal = "ghostty"

    [ui]
    fullscreen = false
    width = 640
    height = 420
  '';

  xdg.configFile."walker/themes/dotfiles.css".text = ''
    * {
      font-family: "JetBrainsMono Nerd Font", monospace;
      font-size: 14px;
    }
  '';

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    splash = false
    ipc = false
    color = rgba(11131aff)
  '';

  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
      lock_cmd = pidof hyprlock || hyprlock
      before_sleep_cmd = loginctl lock-session
      after_sleep_cmd = hyprctl dispatch dpms on
    }

    listener {
      timeout = 300
      on-timeout = loginctl lock-session
    }

    listener {
      timeout = 600
      on-timeout = hyprctl dispatch dpms off
      on-resume = hyprctl dispatch dpms on
    }
  '';

  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
      disable_loading_bar = true
      hide_cursor = true
      no_fade_in = false
    }

    background {
      monitor =
      color = rgba(11131aff)
    }

    label {
      monitor =
      text = cmd[update:1000] date +"%H:%M"
      color = rgba(c0caf5ff)
      font_size = 64
      font_family = JetBrainsMono Nerd Font
      position = 0, 90
      halign = center
      valign = center
    }

    label {
      monitor =
      text = $USER
      color = rgba(7aa2f7ff)
      font_size = 16
      font_family = JetBrainsMono Nerd Font
      position = 0, 20
      halign = center
      valign = center
    }

    input-field {
      monitor =
      size = 260, 44
      outline_thickness = 1
      dots_size = 0.25
      dots_spacing = 0.25
      outer_color = rgba(7aa2f7ff)
      inner_color = rgba(1a1b26ff)
      font_color = rgba(c0caf5ff)
      fade_on_empty = false
      placeholder_text =
      position = 0, -55
      halign = center
      valign = center
    }
  '';
}
