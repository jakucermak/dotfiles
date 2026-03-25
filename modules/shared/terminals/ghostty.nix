{ ... }:
{

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
    theme = light:ayu_light_c,dark:ayu_dark
    background-opacity = 0.85
    background-blur-radius = 90

    # Cursor
    cursor-style = block
    mouse-hide-while-typing = true

    # Padding
    window-padding-balance = true
    window-padding-color = extend
    window-padding-x = 10,10
    window-padding-y = 0,0

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

  xdg.configFile."ghostty/themes/ayu_dark".text = ''
    palette = 0=#5A6673
    palette = 1=#E6495A
    palette = 2=#97C142
    palette = 3=#E89D37
    palette = 4=#17ACF2
    palette = 5=#C385FE
    palette = 6=#84CEB5
    palette = 7=#FFFFFF
    palette = 8=#0A0000
    palette = 9=#F07178
    palette = 10=#AAD94C
    palette = 11=#FFB454
    palette = 12=#59C2FF
    palette = 13=#D2A6FF
    palette = 14=#95E6CB
    palette = 15=#FFFFFF
    background =#10141C
    foreground =#BFBDB6
    cursor-color =#E6B450
  '';

  xdg.configFile."ghostty/themes/ayu_light_c".text = ''
    palette = 0=#ADAEB1
    palette = 1=#F07171
    palette = 2=#86B300
    palette = 3=#EBA400
    palette = 4=#22A4E6
    palette = 5=#A37ACC
    palette = 6=#4CBF99
    palette = 7=#ADAEB1
    palette = 8=#939498
    palette = 9=#F07171
    palette = 10=#86B300
    palette = 11=#EBA400
    palette = 12=#22A4E6
    palette = 13=#A37ACC
    palette = 14=#4CBF99
    palette = 15=#C5C5C8
    background =#FCFCFC
    foreground =#5C6166
    cursor-color =#F29718
  '';
}
