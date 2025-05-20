{ pkgs, ... }: {

  xdg.configFile."ghostty/config".text = ''
    # Fonts
    font-family = JetBrainsMono Nerd Font
    font-feature = +ss01
    font-feature = +ss02
    font-feature = +ss04
    font-feature = +ss05
    font-size = 15
    freetype-load-flags = no-hinting
    window-colorspace = srgb

    # Theme
    theme = light:ayu_light,dark:ayu
    background-opacity = 0.85
    background-blur-radius = 90

    # Shell
    command = ${pkgs.zellij}/bin/zellij attach --create main

    # Cursor
    cursor-style = block
    mouse-hide-while-typing = true

    # Padding
    window-padding-balance = true
    window-padding-color = extend
    window-padding-x = 10,10

    # macOS
    macos-titlebar-style = transparent
    macos-titlebar-proxy-icon = hidden
    confirm-close-surface = false

    term = xterm-256color

    # Keybindings
    macos-option-as-alt = true
    keybind = cmd+right=text:\x05
    keybind = cmd+left=text:\x01
    keybind = alt+left=esc:b
    keybind = alt+right=esc:f

  '';

  xdg.configFile."ghostty/themes/ayu".text = ''
    palette = 0=#51576d
    palette = 1=#F07178
    palette = 2=#AAD94C
    palette = 3=#FFB454
    palette = 4=#8caaee
    palette = 5=#f4b8e4
    palette = 6=#81c8be
    palette = 7=#BFBDB6
    palette = 8=#626880
    palette = 9=#D95757
    palette = 10=#8ec772
    palette = 11=#E6B450
    palette = 12=#7b9ef0
    palette = 13=#f2a4db
    palette = 14=#5abfb5
    palette = 15=#b5bfe2
    background = #0D1017

  '';

  xdg.configFile."ghostty/themes/ayu_light".text = "\n";
}
