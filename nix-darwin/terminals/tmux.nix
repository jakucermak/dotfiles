{ config, pkgs, ... }:
let
  colors = {
    black = "#101521";
    blue = "#5CCFE6";
    yellow = "#F4B664";
    red = "#F28779";
    white = "#CBCCC6";
    green = "#9FBF57";
    visual_grey = "#607080";
    comment_grey = "#5C6773";
  };
in {
  programs.tmux = {
    enable = true;
    prefix = "M-b";
    shell = "${pkgs.zsh}/bin/zsh";
    baseIndex = 1;
    mouse = true;
    terminal = "screen-256color";

    # Plugins
    plugins = with pkgs; [ tmuxPlugins.yank ];

    extraConfig = ''
      # Status bar settings
      set-option -g status on
      set-option -g status-justify centre
      set-option -g status-position top

      set-option -g status-left-length 100
      set-option -g status-right-length 100

      # Message styling
      set-option -g message-style fg=${colors.white},bg=${colors.black}
      set-option -g message-command-style fg=${colors.white},bg=${colors.black}

      # Window status styling
      set-window-option -g window-status-style fg=${colors.black},bg=${colors.black}
      set-window-option -g window-status-activity-style fg=${colors.black},bg=${colors.black}
      set-window-option -g window-status-separator ""

      # Pane styling
      set-option -g window-style fg=${colors.comment_grey}
      set-option -g window-active-style fg=${colors.white}

      set-option -g pane-border-style fg=${colors.white}
      set-option -g pane-active-border-style fg=${colors.green}

      # Display panes
      set-option -g display-panes-active-colour yellow
      set-option -g display-panes-colour blue

      # Status bar colors
      set-option -g status-style fg=white,bg=default

      # Prefix highlight colors
      set -g @prefix_highlight_fg black
      set -g @prefix_highlight_bg green
      set -g @prefix_highlight_copy_mode_attr "fg=black,bg=green"
      set -g @prefix_highlight_output_prefix " "

      # Status line formatting
      set-option -g status-right "#[fg=${colors.visual_grey},bg=default]#[fg=${colors.visual_grey},bg=${colors.visual_grey}]#[fg=white,bg=${colors.visual_grey}] #[fg=green,bg=${colors.visual_grey},nobold,nounderscore,noitalics]#[fg=black,bg=green,bold] #h #[fg=green,bg=default]"
      set-option -g status-left "#[fg=green,bg=default]#[fg=black,bg=green,bold]   #S #{prefix_highlight}  #[fg=green,bg=default,nobold,nounderscore,noitalics]"

      set-window-option -g window-status-format "#[fg=default,bg=default,nobold]#[fg=${colors.white},bg=default] #I  #W "
      set-window-option -g window-status-current-format "#[fg=yellow,bg=default,nobold,nounderscore,noitalics]#[fg=black,bg=yellow,nobold] #I  #W #[fg=yellow,bg=default,nobold,nounderscore,noitalics]"

      # Original key bindings
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -n M-h resize-pane -L 1
      bind -n M-l resize-pane -R 1
      bind -n M-k resize-pane -U 1
      bind -n M-j resize-pane -D 1

      bind C-p previous-window
      bind C-n next-window

      bind | split-pane -h
      bind - split-pane -v
      unbind '"'
      unbind %
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf
      bind y set-window-option synchronize-panes

      # Window/Pane settings
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Vi mode
      set-window-option -g mode-keys vi
    '';
  };
}

# # Copy mode bindings
# bind-key -T copy-mode-vi v send-keys -X begin-selection
# bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
# bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
# '';
