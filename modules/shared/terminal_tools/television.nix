{ pkgs, ... }:
{

  home.packages = [ pkgs.television ];

  xdg.configFile."television/config.toml".force = true;
  xdg.configFile."television/config.toml".text = ''
    tick_rate = 50
    default_channel = "files"
    global_history = false

    [ui]
    ui_scale = 100
    theme = "ayu-dark"

    [ui.input_bar]
    position = "top"
    prompt = ">"
    border_type = "rounded" # https://docs.rs/ratatui/latest/ratatui/widgets/block/enum.BorderType.html#variants

    [ui.status_bar]
    # Status bar separators (bubble):
    #separator_open = ""
    #separator_close = ""
    # Status bar separators (box):
    separator_open = ""
    separator_close = ""
    hidden = false

    [ui.results_panel]
    border_type = "rounded"
    # padding = {"left": 0, "right": 0, "top": 0, "bottom": 0}

    [ui.preview_panel]
    # Preview panel size (percentage of screen width/height)
    size = 50
    #header = ""
    #footer = ""
    scrollbar = true
    border_type = "rounded"
    # padding = {"left": 0, "right": 0, "top": 0, "bottom": 0}
    hidden = false

    [ui.help_panel]
    # Whether to split the help panel by categories
    show_categories = true
    hidden = true

    [ui.remote_control]
    show_channel_descriptions = true
    sort_alphabetically = true
    # disabled = false

    # Keybindings and Events
    # ----------------------------------------------------------------------------

    [keybindings]
    # Application control
    # ------------------
    esc = "quit"
    ctrl-c = "quit"

    # Navigation and selection
    # -----------------------
    down = "select_next_entry"
    ctrl-n = "select_next_entry"
    ctrl-j = "select_next_entry"
    up = "select_prev_entry"
    ctrl-p = "select_prev_entry"
    ctrl-k = "select_prev_entry"

    # History navigation
    # -----------------
    ctrl-up = "select_prev_history"
    ctrl-down = "select_next_history"

    # Multi-selection
    # --------------
    tab = "toggle_selection_down"
    backtab = "toggle_selection_up"
    enter = "confirm_selection"

    # Preview panel control
    # --------------------
    pagedown = "scroll_preview_half_page_down"
    pageup = "scroll_preview_half_page_up"
    ctrl-f = "cycle_previews"

    # Data operations
    # --------------
    ctrl-y = "copy_entry_to_clipboard"
    ctrl-r = "reload_source"
    ctrl-s = "cycle_sources"

    # UI Features
    # ----------
    ctrl-t = "toggle_remote_control"
    ctrl-x = "toggle_action_picker"
    ctrl-o = "toggle_preview"
    ctrl-h = "toggle_help"
    f12 = "toggle_status_bar"
    ctrl-l = "toggle_layout"

    # Input field actions
    # ----------------------------------------
    backspace = "delete_prev_char"
    ctrl-w = "delete_prev_word"
    ctrl-u = "delete_line"
    delete = "delete_next_char"
    left = "go_to_prev_char"
    right = "go_to_next_char"
    home = "go_to_input_start"
    ctrl-a = "go_to_input_start"
    end = "go_to_input_end"
    ctrl-e = "go_to_input_end"

    # Shell integration
    # ----------------------------------------------------------------------------
    #
    # The shell integration feature allows you to use television as a picker for
    # your shell commands (as well as your shell history with <CTRL-R>).
    # E.g. typing `git checkout <CTRL-T>` will open television with a list of
    # branches to choose from.

    [shell_integration]
    # This specifies the default fallback channel if no other channel is matched.
    fallback_channel = "files"

    [shell_integration.channel_triggers]
    # Add your channel triggers here. Each key is a channel that will be triggered
    # by the corresponding commands.
    # Example: say you want the following commands to trigger the following channels
    # when pressing <CTRL-T>:
    #          `git checkout`  should trigger the `git-branches` channel
    #          `ls`            should trigger the `dirs` channel
    #          `cat` and `cp`  should trigger the `files` channel
    #
    # You would add the following to your configuration file:
    # ```
    # [shell_integration.channel_triggers]
    # "git-branches" = ["git checkout"]
    # "dirs" = ["ls"]
    # "files" = ["cat", "cp"]
    # ```
    "alias" = ["alias", "unalias"]
    "env" = ["export", "unset"]
    "dirs" = ["cd", "ls", "rmdir", "z"]
    "files" = [
      "cat",
      "less",
      "head",
      "tail",
      "vim",
      "nano",
      "bat",
      "cp",
      "mv",
      "rm",
      "touch",
      "chmod",
      "chown",
      "ln",
      "tar",
      "zip",
      "unzip",
      "gzip",
      "gunzip",
      "xz",
    ]
    "git-diff" = ["git add", "git restore"]
    "git-branch" = [
      "git checkout",
      "git branch",
      "git merge",
      "git rebase",
      "git pull",
      "git push",
    ]
    "git-log" = ["git log", "git show"]
    "docker-images" = ["docker run"]
    "git-repos" = ["nvim", "code", "hx", "git clone"]


    [shell_integration.keybindings]
    # controls which key binding should trigger tv
    # for shell autocomplete
    "smart_autocomplete" = "ctrl-t"
    # controls which keybinding should trigger tv
    # for command history
    "command_history" = "ctrl-r"
  '';

  xdg.configFile."television/themes/ayu-dark.toml".force = true;
  xdg.configFile."television/themes/ayu-dark.toml".text = ''
    # general
    background = '#0f1419'
    border_fg = '#3d4f5c'
    text_fg = '#e6e1cf'
    dimmed_text_fg = '#5c6773'
    # input
    input_text_fg = '#f07178'
    result_count_fg = '#f07178'
    # results
    result_name_fg = '#39bae6'
    result_line_number_fg = '#e7c547'
    result_value_fg = '#b8cc52'
    selection_fg = '#b8cc52'
    selection_bg = '#253340'
    match_fg = '#ff7733'
    # preview
    preview_title_fg = '#a37acc'
    # modes
    channel_mode_fg = '#0f1419'
    channel_mode_bg = '#ee9ae5'
    remote_control_mode_fg = '#0f1419'
    remote_control_mode_bg = '#b8cc52'
    send_to_channel_mode_fg = '#36a3d9'
  '';

  xdg.configFile."television/channels/sesh.toml".force = true;
  xdg.configFile."television/channels/sesh.toml".text = ''
    [metadata]
    name = "sesh"
    description = "Session manager integrating tmux sessions, zoxide directories, and config paths"
    requirements = [ "sesh", "fd",]

    [source]
    command = [ "sesh list --icons", "sesh list -t --icons", "sesh list -c --icons", "sesh list -z --icons", "fd -H -d 2 -t d -E .Trash . ~",]
    ansi = true
    output = "{strip_ansi|split: :1..|join: }"

    [preview]
    command = "sesh preview '{strip_ansi|split: :1..|join: }'"

    [keybindings]
    enter = "actions:connect"
    ctrl-d = [ "actions:kill_session", "reload_source",]

    [actions.connect]
    description = "Connect to selected session"
    command = "sesh connect '{strip_ansi|split: :1..|join: }'"
    mode = "execute"

    [actions.kill_session]
    description = "Kill selected tmux session (press Ctrl+r to reload)"
    command = "tmux kill-session -t '{strip_ansi|split: :1..|join: }'"
    mode = "fork"
  '';
}
