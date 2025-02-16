{ pkgs, zjstatus, ... }:
let
  colors = {
    green = "#AAD94C";
    orange = "#FFB454";
    d_orange = "#2e210f";
    red = "#F07178";
    yellow = "#F4B664";
    bg = "#0D1017";
    blue = "#39BAE6";
    d_blue = "#062b37";
    magenta = "#D2A6FF";
  };
in {
  home.packages = with pkgs; [ zellij ];

  xdg.configFile."zellij/config.kdl".text = ''

    keybinds clear-defaults=true {
        locked {
            bind "alt g" { SwitchToMode "normal"; }
        }
        pane {
            bind "left" { MoveFocus "left"; }
            bind "down" { MoveFocus "down"; }
            bind "up" { MoveFocus "up"; }
            bind "right" { MoveFocus "right"; }
            bind "r" { SwitchToMode "renamepane"; PaneNameInput 0; }
            bind "v" { NewPane "down"; SwitchToMode "normal"; }
            bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "normal"; }
            bind "f" { ToggleFocusFullscreen; SwitchToMode "normal"; }
            bind "h" { MoveFocus "left"; }
            bind "j" { MoveFocus "down"; }
            bind "k" { MoveFocus "up"; }
            bind "l" { MoveFocus "right"; }
            bind "n" { NewPane; SwitchToMode "normal"; }
            bind "p" { SwitchFocus; }
            bind "Alt p" { SwitchToMode "normal"; }
            bind "w" { ToggleFloatingPanes; SwitchToMode "normal"; }
            bind "z" { TogglePaneFrames; SwitchToMode "normal"; }
        }
        tab {
            bind "left" { GoToPreviousTab; }
            bind "down" { GoToNextTab; }
            bind "up" { GoToPreviousTab; }
            bind "right" { GoToNextTab; }
            bind "1" { GoToTab 1; SwitchToMode "normal"; }
            bind "2" { GoToTab 2; SwitchToMode "normal"; }
            bind "3" { GoToTab 3; SwitchToMode "normal"; }
            bind "4" { GoToTab 4; SwitchToMode "normal"; }
            bind "5" { GoToTab 5; SwitchToMode "normal"; }
            bind "6" { GoToTab 6; SwitchToMode "normal"; }
            bind "7" { GoToTab 7; SwitchToMode "normal"; }
            bind "8" { GoToTab 8; SwitchToMode "normal"; }
            bind "9" { GoToTab 9; SwitchToMode "normal"; }
            bind "[" { BreakPaneLeft; SwitchToMode "normal"; }
            bind "]" { BreakPaneRight; SwitchToMode "normal"; }
            bind "b" { BreakPane; SwitchToMode "normal"; }
            bind "h" { GoToPreviousTab; }
            bind "j" { GoToNextTab; }
            bind "k" { GoToPreviousTab; }
            bind "l" { GoToNextTab; }
            bind "n" { NewTab; SwitchToMode "normal"; }
            bind "r" { SwitchToMode "renametab"; TabNameInput 0; }
            bind "s" { ToggleActiveSyncTab; SwitchToMode "normal"; }
            bind "alt t" { SwitchToMode "normal"; }
            bind "x" { CloseTab; SwitchToMode "normal"; }
            bind "tab" { ToggleTab; }
        }
        resize {
            bind "left" { Resize "Increase left"; }
            bind "down" { Resize "Increase down"; }
            bind "up" { Resize "Increase up"; }
            bind "right" { Resize "Increase right"; }
            bind "+" { Resize "Increase"; }
            bind "-" { Resize "Decrease"; }
            bind "=" { Resize "Increase"; }
            bind "H" { Resize "Decrease left"; }
            bind "J" { Resize "Decrease down"; }
            bind "K" { Resize "Decrease up"; }
            bind "L" { Resize "Decrease right"; }
            bind "h" { Resize "Increase left"; }
            bind "j" { Resize "Increase down"; }
            bind "k" { Resize "Increase up"; }
            bind "l" { Resize "Increase right"; }
            bind "Ctrl n" { SwitchToMode "normal"; }
        }
        move {
            bind "left" { MovePane "left"; }
            bind "down" { MovePane "down"; }
            bind "up" { MovePane "up"; }
            bind "right" { MovePane "right"; }
            bind "h" { MovePane "left"; }
            bind "Ctrl h" { SwitchToMode "normal"; }
            bind "j" { MovePane "down"; }
            bind "k" { MovePane "up"; }
            bind "l" { MovePane "right"; }
            bind "n" { MovePane; }
            bind "p" { MovePaneBackwards; }
            bind "tab" { MovePane; }
        }
        scroll {
            bind "Alt left" { MoveFocusOrTab "left"; SwitchToMode "normal"; }
            bind "Alt down" { MoveFocus "down"; SwitchToMode "normal"; }
            bind "Alt up" { MoveFocus "up"; SwitchToMode "normal"; }
            bind "Alt right" { MoveFocusOrTab "right"; SwitchToMode "normal"; }
            bind "e" { EditScrollback; SwitchToMode "normal"; }
            bind "Alt h" { MoveFocusOrTab "left"; SwitchToMode "normal"; }
            bind "Alt j" { MoveFocus "down"; SwitchToMode "normal"; }
            bind "Alt k" { MoveFocus "up"; SwitchToMode "normal"; }
            bind "Alt l" { MoveFocusOrTab "right"; SwitchToMode "normal"; }
            bind "s" { SwitchToMode "entersearch"; SearchInput 0; }
        }
        search {
            bind "c" { SearchToggleOption "CaseSensitivity"; }
            bind "n" { Search "down"; }
            bind "o" { SearchToggleOption "WholeWord"; }
            bind "p" { Search "up"; }
            bind "w" { SearchToggleOption "Wrap"; }
        }
        session {
            bind "c" {
                LaunchOrFocusPlugin "configuration" {
                    floating true
                    move_to_focused_tab true
                }
                SwitchToMode "normal"
            }
            bind "Alt s" { SwitchToMode "normal"; }
            bind "p" {
                LaunchOrFocusPlugin "plugin-manager" {
                    floating true
                    move_to_focused_tab true
                }
                SwitchToMode "normal"
            }
            bind "s" {
                LaunchOrFocusPlugin "session-manager" {
                    floating true
                    move_to_focused_tab true
                }
                SwitchToMode "normal"
            }
        }
        shared_except "locked" {
            bind "Alt +" { Resize "Increase"; }
            bind "Alt -" { Resize "Decrease"; }
            bind "Alt =" { Resize "Increase"; }
            bind "Alt [" { PreviousSwapLayout; }
            bind "Alt ]" { NextSwapLayout; }
            bind "Alt f" { ToggleFloatingPanes; }
            bind "Ctrl g" { SwitchToMode "locked"; }
            bind "Alt i" { MoveTab "left"; }
            bind "Alt n" { NewPane; }
            bind "Alt o" { MoveTab "right"; }
        }
        shared_except "locked" "move" {
            bind "Ctrl m" { SwitchToMode "move"; }
        }
        shared_except "locked" "session" {
            bind "Alt s" { SwitchToMode "session"; }
        }
        shared_except "locked" "scroll" {
            bind "Ctrl h" { MoveFocusOrTab "left"; }
            bind "Ctrl j" { MoveFocus "down"; }
            bind "Ctrl k" { MoveFocus "up"; }
            bind "Ctrl l" { MoveFocusOrTab "right"; }
        }
        shared_except "locked" "scroll" "search" "tmux" {
            bind "Ctrl b" { SwitchToMode "tmux"; }
        }
        shared_except "locked" "scroll" "search" {
            bind "Ctrl s" { SwitchToMode "scroll"; }
        }
        shared_except "locked" "tab" {
            bind "Alt t" { SwitchToMode "tab"; }
        }
        shared_except "locked" "pane" {
            bind "Alt p" { SwitchToMode "pane"; }
        }
        shared_except "locked" "resize" {
            bind "Ctrl n" { SwitchToMode "resize"; }
        }
        shared_except "normal" "locked" "entersearch" {
            bind "enter" { SwitchToMode "normal"; }
        }
        shared_except "normal" "locked" "entersearch" "renametab" "renamepane" {
            bind "esc" { SwitchToMode "normal"; }
        }
        shared_among "pane" "tmux" {
            bind "x" { CloseFocus; SwitchToMode "normal"; }
        }
        shared_among "scroll" "search" {
            bind "PageDown" { PageScrollDown; }
            bind "PageUp" { PageScrollUp; }
            bind "left" { PageScrollUp; }
            bind "down" { ScrollDown; }
            bind "up" { ScrollUp; }
            bind "right" { PageScrollDown; }
            bind "Ctrl b" { PageScrollUp; }
            bind "Ctrl c" { ScrollToBottom; SwitchToMode "normal"; }
            bind "d" { HalfPageScrollDown; }
            bind "Ctrl f" { PageScrollDown; }
            bind "h" { PageScrollUp; }
            bind "j" { ScrollDown; }
            bind "k" { ScrollUp; }
            bind "l" { PageScrollDown; }
            bind "Ctrl s" { SwitchToMode "normal"; }
            bind "u" { HalfPageScrollUp; }
        }
        entersearch {
            bind "Ctrl c" { SwitchToMode "scroll"; }
            bind "esc" { SwitchToMode "scroll"; }
            bind "enter" { SwitchToMode "search"; }
        }
        renametab {
            bind "esc" { UndoRenameTab; SwitchToMode "tab"; }
        }
        shared_among "renametab" "renamepane" {
            bind "Ctrl c" { SwitchToMode "normal"; }
        }
        renamepane {
            bind "esc" { UndoRenamePane; SwitchToMode "pane"; }
        }
        shared_among "session" "tmux" {
            bind "d" { Detach; }
        }
    }

  '';
  xdg.configFile."zellij/layouts/default.kdl".text = ''
    layout {
              default_tab_template {
                  pane size=1 borderless=true {
                    plugin location="file://${zjstatus}/bin/zjstatus.wasm" {
                        format_left   "{mode}#[bg=${colors.bg}] {tabs}"
                        format_center ""
                        format_right  "#[bg=${colors.bg},fg=${colors.blue}]█#[bg=${colors.blue},fg=${colors.bg},bold] #[bg=${colors.d_blue},fg=${colors.blue},bold] {session} #[bg=${colors.bg},fg=${colors.d_blue},bold]"
                        format_space  ""
                        format_hide_on_overlength "true"
                        format_precedence "crl"

                        border_enabled  "false"
                        border_char     "─"
                        border_format   "#[fg=#6C7086]{char}"
                        border_position "top"

                        mode_normal        "#[bg=${colors.green},fg=${colors.bg},bold] NORMAL#[bg=${colors.bg},fg=${colors.green}]█"
                        mode_locked        "#[bg=#6e738d,fg=${colors.bg},bold] LOCKED #[bg=${colors.bg},fg=#6e738d]█"
                        mode_resize        "#[bg=${colors.green},fg=${colors.bg},bold] RESIZE#[bg=${colors.bg},fg=${colors.green}]█"
                        mode_pane          "#[bg=${colors.blue},fg=${colors.bg},bold] PANE#[bg=${colors.bg},fg=${colors.blue}]█"
                        mode_tab           "#[bg=${colors.orange},fg=${colors.bg},bold] TAB#[bg=${colors.bg},fg=${colors.orange}]█"
                        mode_scroll        "#[bg=#f9e2af,fg=${colors.bg},bold] SCROLL#[bg=${colors.bg},fg=#f9e2af]█"
                        mode_enter_search  "#[bg=${colors.magenta},fg=${colors.bg},bold] ENT-SEARCH#[bg=${colors.bg},fg=${colors.magenta}]█"
                        mode_search        "#[bg=${colors.magenta},fg=${colors.bg},bold] SEARCHARCH#[bg=${colors.bg},fg=${colors.magenta}]█"
                        mode_rename_tab    "#[bg=${colors.orange},fg=${colors.bg},bold] RENAME-TAB#[bg=${colors.bg},fg=${colors.orange}]█"
                        mode_rename_pane   "#[bg=${colors.blue},fg=${colors.bg},bold] RENAME-PANE#[bg=${colors.bg},fg=${colors.blue}]█"
                        mode_session       "#[bg=${colors.magenta},fg=${colors.bg},bold] SESSION#[bg=${colors.bg},fg=${colors.magenta}]█"
                        mode_move          "#[bg=${colors.red},fg=${colors.bg},bold] MOVE#[bg=${colors.bg},fg=${colors.red}]█"
                        mode_prompt        "#[bg=${colors.magenta},fg=${colors.bg},bold] PROMPT#[bg=${colors.bg},fg=${colors.magenta}]█"
                        mode_tmux          "#[bg=#f5a97f,fg=${colors.bg},bold] TMUX#[bg=${colors.bg},fg=#f5a97f]█"

                        // formatting for inactive tabs
                        tab_normal              "#[bg=${colors.bg},fg=${colors.blue}]█#[bg=${colors.blue},fg=${colors.bg},bold]{index} #[bg=${colors.d_blue},fg=${colors.blue},bold] {name}{floating_indicator}#[bg=${colors.bg},fg=${colors.d_blue},bold]█"
                        tab_normal_fullscreen   "#[bg=${colors.bg},fg=${colors.blue}]█#[bg=${colors.blue},fg=${colors.bg},bold]{index} #[bg=${colors.d_blue},fg=${colors.blue},bold] {name}{fullscreen_indicator}#[bg=${colors.bg},fg=${colors.d_blue},bold]█"
                        tab_normal_sync         "#[bg=${colors.bg},fg=${colors.blue}]█#[bg=${colors.blue},fg=${colors.bg},bold]{index} #[bg=${colors.d_blue},fg=${colors.blue},bold] {name}{sync_indicator}#[bg=${colors.bg},fg=${colors.d_blue},bold]█"

                        // formatting for the current active tab
                        tab_active              "#[bg=${colors.bg},fg=${colors.orange}]█#[bg=${colors.orange},fg=${colors.bg},bold]{index} #[bg=${colors.d_orange},fg=${colors.orange},bold] {name}{floating_indicator}#[bg=${colors.bg},fg=${colors.d_orange},bold]█"
                        tab_active_fullscreen   "#[bg=${colors.bg},fg=${colors.orange}]█#[bg=${colors.orange},fg=${colors.bg},bold]{index} #[bg=${colors.d_orange},fg=${colors.orange},bold] {name}{fullscreen_indicator}#[bg=${colors.bg},fg=${colors.d_orange},bold]█"
                        tab_active_sync         "#[bg=${colors.bg},fg=${colors.orange}]█#[bg=${colors.orange},fg=${colors.bg},bold]{index} #[bg=${colors.d_orange},fg=${colors.orange},bold] {name}{sync_indicator}#[bg=${colors.bg},fg=${colors.d_orange},bold]█"

                        // separator between the tabs
                        tab_separator           "#[bg=#${colors.bg}] "

                        // indicators
                        tab_sync_indicator       "  "
                        tab_fullscreen_indicator " 󰊓 "
                        tab_floating_indicator   " 󰹙 "

                        command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                        command_git_branch_format      "#[fg=blue] {stdout} "
                        command_git_branch_interval    "10"
                        command_git_branch_rendermode  "static"

                        datetime        "#[fg=#6C7086,bold] {format} "
                        datetime_format "%A, %d %b %Y %H:%M"
                        datetime_timezone "Europe/London"
                      }
                  }
                  children
              }
          }
  '';

  programs.zellij = {
    enable = true;
    settings = {
      theme = "ayu_dark";
      default_layout = "default";
      pane_frames = false;
      ui.pane_frames.rounded_corners = true;
      default_mode = "normal";
    };
  };
}
