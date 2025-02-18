{ config, pkgs, libs, ... }: {
  home.packages = with pkgs; [ aerospace jankyborders sketchybar ];

  xdg.configFile."aerospace/aerospace.toml".text = ''
    # Place a copy of this config to ~/.aerospace.toml
    # After that, you can edit ~/.aerospace.toml to your liking

    # You can use it to add commands that run after login to macOS user session.
    # 'start-at-login' needs to be 'true' for 'after-login-command' to work
    # Available commands: https://nikitabobko.github.io/AeroSpace/commands
    after-login-command = []

    # You can use it to add commands that run after AeroSpace startup.
    # 'after-startup-command' is run after 'after-login-command'
    # Available commands : https://nikitabobko.github.io/AeroSpace/commands
    after-startup-command = [
            'exec-and-forget /opt/homebrew/bin/sketchybar',
            'exec-and-forget ${pkgs.zsh}/bin/zsh -c ${pkgs.jankyborders}/bin/borders',
        ]

    exec-on-workspace-change = [
            '/bin/bash',
            '-c',
            '/opt/homebrew/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE',

    ]

    # Start AeroSpace at login
    start-at-login = true

    # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
    enable-normalization-flatten-containers = true
    enable-normalization-opposite-orientation-for-nested-containers = true

    # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
    # The 'accordion-padding' specifies the size of accordion padding
    # You can set 0 to disable the padding feature
    accordion-padding = 30

    # Possible values: tiles|accordion
    default-root-container-layout = 'tiles'

    # Possible values: horizontal|vertical|auto
    # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
    #               tall monitor (anything higher than wide) gets vertical orientation
    default-root-container-orientation = 'auto'

    # Mouse follows focus when focused monitor changes
    # Drop it from your config, if you don't like this behavior
    # See https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
    # See https://nikitabobko.github.io/AeroSpace/commands#move-mouse
    # Fallback value (if you omit the key): on-focused-monitor-changed = []
    on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

    # You can effectively turn off macOS "Hide application" (cmd-h) feature by toggling this flag
    # Useful if you don't use this macOS feature, but accidentally hit cmd-h or cmd-alt-h key
    # Also see: https://nikitabobko.github.io/AeroSpace/goodies#disable-hide-app
    automatically-unhide-macos-hidden-apps = true

    # Possible values: (qwerty|dvorak)
    # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
    [key-mapping]
    preset = 'qwerty'

    # Gaps between windows (inner-*) and between monitor edges (outer-*).
    # Possible values:
    # - Constant:     gaps.outer.top = 8
    # - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
    #                 In this example, 24 is a default value when there is no match.
    #                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
    #                 See: https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
    [gaps]
    inner.horizontal = 10
    inner.vertical = 10
    outer.left = 10
    outer.bottom = 10
    outer.top = 10
    outer.right = 10

    # 'main' binding mode declaration
    # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
    # 'main' binding mode must be always presented
    # Fallback value (if you omit the key): mode.main.binding = {}
    [mode.main.binding]


    # All possible keys:
    # - Letters.        a, b, c, ..., z
    # - Numbers.        0, 1, 2, ..., 9
    # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
    # - F-keys.         f1, f2, ..., f20
    # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
    #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
    # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
    #                   keypadMinus, keypadMultiply, keypadPlus
    # - Arrows.         left, down, up, right

    # All possible modifiers: cmd, alt, ctrl, shift

    # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

    # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
    # You can uncomment the following lines to open up terminal with alt + enter shortcut (like in i3)
    alt-enter = 'exec-and-forget   open -n  /Users/jakubcermak/Applications/Home\ Manager\ Apps/Alacritty.app'


    # See: https://nikitabobko.github.io/AeroSpace/commands#layout
    alt-slash = 'layout tiles horizontal vertical'
    alt-comma = 'layout accordion horizontal vertical'

    # See: https://nikitabobko.github.io/AeroSpace/commands#focus
    alt-h = 'focus left'
    alt-j = 'focus down'
    alt-k = 'focus up'
    alt-l = 'focus right'

    # See: https://nikitabobko.github.io/AeroSpace/commands#move
    alt-shift-h = 'move left'
    alt-shift-j = 'move down'
    alt-shift-k = 'move up'
    alt-shift-l = 'move right'

    # See: https://nikitabobko.github.io/AeroSpace/commands#resize
    alt-shift-minus = 'resize smart -50'
    alt-shift-equal = 'resize smart +50'

    # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
    alt-1 = 'workspace 1'
    alt-2 = 'workspace 2'
    alt-3 = 'workspace 3'
    alt-4 = 'workspace 4'
    alt-5 = 'workspace 5'
    alt-6 = 'workspace 6'
    alt-7 = 'workspace 7'
    alt-8 = 'workspace 8'
    alt-9 = 'workspace 9'

    # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
    alt-shift-1 = 'move-node-to-workspace 1'
    alt-shift-2 = 'move-node-to-workspace 2'
    alt-shift-3 = 'move-node-to-workspace 3'
    alt-shift-4 = 'move-node-to-workspace 4'
    alt-shift-5 = 'move-node-to-workspace 5'
    alt-shift-6 = 'move-node-to-workspace 6'
    alt-shift-7 = 'move-node-to-workspace 7'
    alt-shift-8 = 'move-node-to-workspace 8'
    alt-shift-9 = 'move-node-to-workspace 9'

    # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
    # alt-tab = 'workspace-back-and-forth'
    # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
    # alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'

    # See: https://nikitabobko.github.io/AeroSpace/commands#mode
    alt-shift-semicolon = 'mode service'

    # 'service' binding mode declaration.
    # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
    [mode.service.binding]
    esc = ['reload-config', 'mode main']
    r = ['flatten-workspace-tree', 'mode main'] # reset layout
    f = [
        'layout floating tiling',
        'mode main',
    ] # Toggle between floating and tiling layout
    backspace = ['close-all-windows-but-current', 'mode main']

    # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
    #s = ['layout sticky tiling', 'mode main']

    alt-shift-h = ['join-with left', 'mode main']
    alt-shift-j = ['join-with down', 'mode main']
    alt-shift-k = ['join-with up', 'mode main']
    alt-shift-l = ['join-with right', 'mode main']


    down = 'volume down'
    up = 'volume up'
    shift-down = ['volume set 0', 'mode main']

    [[on-window-detected]]
    if.app-id = 'com.sigmaos.sigmaos.macos'
    run = 'move-node-to-workspace 1'

    [[on-window-detected]]
    if.app-id = 'com.apple.finder'
    run = 'move-node-to-workspace 1'

    [[on-window-detected]]
    if.app-id = 'com.apple.dt.Xcode'
    run = 'move-node-to-workspace 2'

    [[on-window-detected]]
    if.app-id = 'dev.zed.Zed-Preview'
    run = 'move-node-to-workspace 2'

    [[on-window-detected]]
    if.app-id = 'org.alacritty'
    run = 'move-node-to-workspace 3'

    [[on-window-detected]]
    if.app-id = 'com.mitchellh.ghostty'
    run = 'move-node-to-workspace 3'

    [[on-window-detected]]
    if.app-id = 'com.apple.MobileSMS'
    run = 'move-node-to-workspace 4'

    [[on-window-detected]]
    if.app-id = 'com.tinyspeck.slackmacgap'
    run = 'move-node-to-workspace 4'

    [[on-window-detected]]
    if.app-id = 'com.openai.chat'
    run = 'move-node-to-workspace 4'

    [[on-window-detected]]
    if.app-id = 'com.readdle.SparkDesktop.appstore'
    run = 'move-node-to-workspace 5'

    [[on-window-detected]]
    if.app-id = 'com.apple.Music'
    run = 'move-node-to-workspace 6'

    [workspace-to-monitor-force-assignment]
    1 = 'main'        # Monitor sequence number from left to right. 1-based indexing
    2 = 'main'        # Main monitor
    3 = 'main'        # Main monitor
    4 = 'main'        # Main monitor
    5 = 'main'        # Main monitor
    6 = 'main'        # Main monitor
    7 = 'main'        # Main monitor
    8 = ['secondary']
    9 = ['secondary']
  '';
  #
  # Borders configuration
  xdg.configFile."borders/bordersrc".executable = true;
  xdg.configFile."borders/bordersrc".source = ./borders/bordersrc;

}
