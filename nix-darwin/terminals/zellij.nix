{ pkgs, zjstatus, ... }:
let
  colors = {
    green = "#39BAE6";
    red = "#F28779";
    yellow = "#F4B664";
    background = "#0D1017";
    blue = "#5CCFE6";
    l_blue = "#39BAE6";

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
            bind "Alt h" { MoveFocusOrTab "left"; }
            bind "Alt j" { MoveFocus "down"; }
            bind "Alt k" { MoveFocus "up"; }
            bind "Alt l" { MoveFocusOrTab "right"; }
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
                        format_left   "{mode}#[bg=#181926] {tabs}"
                        format_center ""
                        format_right  "#[bg=#181926,fg=#89b4fa]#[bg=#89b4fa,fg=#1e2030,bold] #[bg=#363a4f,fg=#89b4fa,bold] {session} #[bg=#181926,fg=#363a4f,bold]"
                        format_space  ""
                        format_hide_on_overlength "true"
                        format_precedence "crl"

                        border_enabled  "false"
                        border_char     "─"
                        border_format   "#[fg=#6C7086]{char}"
                        border_position "top"

                        mode_normal        "#[bg=#a6da95,fg=#181926,bold] NORMAL#[bg=#181926,fg=#a6da95]█"
                        mode_locked        "#[bg=#6e738d,fg=#181926,bold] LOCKED #[bg=#181926,fg=#6e738d]█"
                        mode_resize        "#[bg=#f38ba8,fg=#181926,bold] RESIZE#[bg=#181926,fg=#f38ba8]█"
                        mode_pane          "#[bg=#89b4fa,fg=#181926,bold] PANE#[bg=#181926,fg=#89b4fa]█"
                        mode_tab           "#[bg=#b4befe,fg=#181926,bold] TAB#[bg=#181926,fg=#b4befe]█"
                        mode_scroll        "#[bg=#f9e2af,fg=#181926,bold] SCROLL#[bg=#181926,fg=#f9e2af]█"
                        mode_enter_search  "#[bg=#8aadf4,fg=#181926,bold] ENT-SEARCH#[bg=#181926,fg=#8aadf4]█"
                        mode_search        "#[bg=#8aadf4,fg=#181926,bold] SEARCHARCH#[bg=#181926,fg=#8aadf4]█"
                        mode_rename_tab    "#[bg=#b4befe,fg=#181926,bold] RENAME-TAB#[bg=#181926,fg=#b4befe]█"
                        mode_rename_pane   "#[bg=#89b4fa,fg=#181926,bold] RENAME-PANE#[bg=#181926,fg=#89b4fa]█"
                        mode_session       "#[bg=#74c7ec,fg=#181926,bold] SESSION#[bg=#181926,fg=#74c7ec]█"
                        mode_move          "#[bg=#f5c2e7,fg=#181926,bold] MOVE#[bg=#181926,fg=#f5c2e7]█"
                        mode_prompt        "#[bg=#8aadf4,fg=#181926,bold] PROMPT#[bg=#181926,fg=#8aadf4]█"
                        mode_tmux          "#[bg=#f5a97f,fg=#181926,bold] TMUX#[bg=#181926,fg=#f5a97f]█"

                        // formatting for inactive tabs
                        tab_normal              "#[bg=#181926,fg=#89b4fa]█#[bg=#89b4fa,fg=#1e2030,bold]{index} #[bg=#363a4f,fg=#89b4fa,bold] {name}{floating_indicator}#[bg=#181926,fg=#363a4f,bold]█"
                        tab_normal_fullscreen   "#[bg=#181926,fg=#89b4fa]█#[bg=#89b4fa,fg=#1e2030,bold]{index} #[bg=#363a4f,fg=#89b4fa,bold] {name}{fullscreen_indicator}#[bg=#181926,fg=#363a4f,bold]█"
                        tab_normal_sync         "#[bg=#181926,fg=#89b4fa]█#[bg=#89b4fa,fg=#1e2030,bold]{index} #[bg=#363a4f,fg=#89b4fa,bold] {name}{sync_indicator}#[bg=#181926,fg=#363a4f,bold]█"

                        // formatting for the current active tab
                        tab_active              "#[bg=#181926,fg=#fab387]█#[bg=#fab387,fg=#1e2030,bold]{index} #[bg=#363a4f,fg=#fab387,bold] {name}{floating_indicator}#[bg=#181926,fg=#363a4f,bold]█"
                        tab_active_fullscreen   "#[bg=#181926,fg=#fab387]█#[bg=#fab387,fg=#1e2030,bold]{index} #[bg=#363a4f,fg=#fab387,bold] {name}{fullscreen_indicator}#[bg=#181926,fg=#363a4f,bold]█"
                        tab_active_sync         "#[bg=#181926,fg=#fab387]█#[bg=#fab387,fg=#1e2030,bold]{index} #[bg=#363a4f,fg=#fab387,bold] {name}{sync_indicator}#[bg=#181926,fg=#363a4f,bold]█"

                        // separator between the tabs
                        tab_separator           "#[bg=#181926] "

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
