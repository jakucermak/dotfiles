{ pkgs, ... }:
let
  tmux-ayu = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-ayu";
    rtpFilePath = "ayu.tmux";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "jakucermak";
      repo = "tmux-ayu";
      rev = "f95604c01357425b741d03dc5dcef170a6e9dd17";
      sha256 = "sha256-EkluxQjZDgLOsOABRi4NuKXpSP71joMQYTNQsPen9EU=";
    };
  };

  # tmux-dark-notify-src = pkgs.fetchFromGitHub {
  #   owner = "erikw";
  #   repo = "tmux-dark-notify";
  #   rev = "49d12c539f655523726b57cf464ecb355f1590b7";
  #   sha256 = "sha256-SvzptypGHGuQxGwjEZSy/A0ebb5Te+1eu/2TXJBhJBc=";
  # };

  aw-watcher-tmux-src = pkgs.fetchFromGitHub {
    owner = "akohlbecker";
    repo = "aw-watcher-tmux";
    rev = "efaa7610add52bd2b39cd98d0e8e082b1e126487";
    sha256 = "sha256-L6YLyEOmb+vdz6bJdB0m5gONPpBp2fV3i9PiLSNrZNM=";
  };

  tmux-agent-sidebar = pkgs.callPackage ./tmux-agent-sidebar.nix { };
in
{
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    baseIndex = 1;
    historyLimit = 10000;
    keyMode = "vi";
    terminal = "xterm-256color";

    plugins = with pkgs.tmuxPlugins; [
      tmux-ayu
      tmux-sessionx
      resurrect
      {
        plugin = tmux-agent-sidebar;
        extraConfig = "set -g @sidebar_auto_create off";
      }
    ];

    extraConfig = ''
      # -- Basic Settings --
      set -g status-interval 1
      setw -g pane-base-index 1
      set -g allow-passthrough on
      set -g set-titles off
      set -g renumber-windows on

      # -- Keybindings --
      bind r source-file ~/.config/tmux/tmux.conf
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R
      bind e set-window-option synchronize-panes

      bind-key "T" run-shell "sesh connect \"$(
        sesh list --icons | fzf-tmux -p 80%,70% \
          --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
          --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
          --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
          --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
          --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
          --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
          --preview-window 'right:55%' \
          --preview 'sesh preview {}'
      )\""

      # -- Hooks --
      set-hook -g client-session-changed 'run-shell -b "~/.tmux/tmux-title.sh #{hook_client}"'
      set-hook -g session-window-changed 'run-shell -b "~/.tmux/tmux-title.sh #{hook_client}"'
      set-hook -g window-pane-changed   'run-shell -b "~/.tmux/tmux-title.sh #{hook_client}"'
      set-hook -g pane-title-changed    'run-shell -b "~/.tmux/tmux-title.sh #{hook_client}"'
      set-hook -g after-rename-window   'run-shell -b "~/.tmux/tmux-title.sh #{hook_client}"'
      set-hook -g after-rename-session  'run-shell -b "~/.tmux/tmux-title.sh #{hook_client}"'
      set-hook -g after-select-window 'run-shell "printf \"\033]2;%s\033\\\\\" \"$(tmux display-message -p \"#S:#W\")\" > #{pane_tty}"'
      set-hook -g after-select-pane   'run-shell "printf \"\033]2;%s\033\\\\\" \"$(tmux display-message -p \"#S:#W\")\" > #{pane_tty}"'

      # Configure Ayu
      set -g @ayu_status_background "none"
      set -g @ayu_window_status_style "none"
      set -g @ayu_pane_status_enabled "off"
      set -g @ayu_pane_border_status "off"

      # -- Status left look and feel
      set -g status-left-length 100
      set -g status-left ""
      set -ga status-left "#{?client_prefix,#{#[bg=#{@thm_red},fg=#{@thm_bg},bold]  #S },#{#[bg=#{@thm_bg},fg=#{@thm_green}]  #S }}"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_ui_line},none]│"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_purple}]  #{pane_current_command} "
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_ui_line},none]│"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_blue}]  #{=/-32/...:#{s|$USER|~|:#{b:pane_current_path}}} "
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_ui_line},none]#{?window_zoomed_flag,│,}"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_accent_tint}]#{?window_zoomed_flag,  zoom ,}"
      set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_accent_tint}]#{?pane_synchronized,  sync ,}"

      # -- Status right look and feel
      set -g status-right-length 100
      set -g status-right ""
      set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_blue}] 󰭦 %Y-%m-%d 󰅐 %H:%M "

      # -- Configure Tmux
      set -g status-position top
      set -g status-style "bg=#{@thm_bg}"
      set -g status-justify "absolute-centre"

      # -- Pane border look and feel
      setw -g pane-border-status top
      setw -g pane-border-format ""
      setw -g pane-border-style "bg=#{@thm_bg},fg=#{@thm_ui_line}"
      setw -g pane-active-border-style "bg=#{@thm_bg},fg=#{@thm_accent_tint}"

      setw -g pane-border-lines single

      # -- Window look and feel
      set -wg automatic-rename on
      set -g automatic-rename-format "Window"
      set -g window-status-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-style "bg=#{@thm_bg},fg=#{@thm_blue}"
      set -g window-status-last-style "bg=#{@thm_bg},fg=#{@thm_blue}"
      set -g window-status-activity-style "bg=#{@thm_magenta},fg=#{@thm_bg}"
      set -g window-status-bell-style "bg=#{@thm_red},fg=#{@thm_bg},bold"
      set -gF window-status-separator "#[bg=#{@thm_bg},fg=#{@thm_ui_line}]│"
      set -g window-status-current-format " #I#{?#{!=:#{window_name},Window},: #W,} "
      set -g window-status-current-style "bg=#{@thm_blue},fg=#{@thm_bg},bold"

      # -- Plugin settings --
      # set -g @dark-notify-theme-path-light '$HOME/.tmux/light.conf'
      # set -g @dark-notify-theme-path-dark '$HOME/.tmux/dark.conf'
      set -g @sessionx-tmuxinator-mode 'on'

      # -- Plugins that need user PATH and spawn background processes --
      run-shell "nohup ${aw-watcher-tmux-src}/aw-watcher-tmux.tmux >/dev/null 2>&1 &"

      # -- Local dev plugin --
      run /Users/jakubcermak/Projects/personal/tmux-which/tmux-which.tmux
    '';
  };

  # Supporting files
  home.file.".tmux/tmux-title.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      client="''${1:-}"
      if [ -z "$client" ] || [ "$client" = "-" ]; then
        client="$(tmux display -p '#{client_name}' 2>/dev/null || true)"
      fi

      tty="$(tmux display -p -t "$client" '#{client_tty}' 2>/dev/null || true)"
      [ -n "$tty" ] && [ -w "$tty" ] || exit 0

      title="$(tmux display-message -p '
      #{session_name} | #{?#{==:#{window_name},Window},
      #{pane_current_path} / #{pane_current_command},
      #{window_name}}#{?#{&&:#{>:#{window_panes},1},#{!=:#{window_name},Window}},
       | #{pane_title} / #{pane_current_command},
      }')"

      printf '\033Ptmux;\033\033]2;%s\007\033\\' "$title" > "$tty"
    '';
  };

  home.file.".tmux/dark.conf".text = ''
    set -g @ayu_appearance "dark"
    run ${tmux-ayu}/share/tmux-plugins/tmux-ayu/ayu.tmux
  '';

  home.file.".tmux/light.conf".text = ''
    set -g @ayu_appearance "light"
    run ${tmux-ayu}/share/tmux-plugins/tmux-ayu/ayu.tmux
  '';
}
