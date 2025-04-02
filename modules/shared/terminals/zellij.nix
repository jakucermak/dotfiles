{ pkgs, ... }:
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

  xdg.configFile."zellij/config.kdl".text = ''

    keybinds clear-defaults=true {
        unbind "alt f"
        locked {
            bind "Ctrl g" { SwitchToMode "normal"; }
        }
        pane {
            bind "r" { SwitchToMode "renamepane"; PaneNameInput 0; }
            bind "v" { NewPane "down"; SwitchToMode "normal"; }
            bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "normal"; }
            bind "f" { ToggleFocusFullscreen; SwitchToMode "normal"; }
            bind "h" { MoveFocus "left"; }
            bind "j" { MoveFocus "down"; }
            bind "k" { MoveFocus "up"; }
            bind "l" { MoveFocus "right"; }
            bind "n" { NewPane "right"; SwitchToMode "normal"; }
            bind "p" { SwitchFocus; }
            bind "Alt p" { SwitchToMode "normal"; }
            bind "w" { ToggleFloatingPanes; SwitchToMode "normal"; }
            bind "z" { TogglePaneFrames; SwitchToMode "normal"; }
        }
        tab {
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
            bind "Ctrl f" { ToggleFloatingPanes; }
            bind "Ctrl g" { SwitchToMode "locked"; }
            bind "Alt i" { MoveTab "left"; }
            bind "Alt n" { NewPane; }
            bind "Alt o" { MoveTab "right"; }
        }
        shared_except "locked" "move" {
            bind "Alt m" { SwitchToMode "move"; }
        }
        shared_except "locked" "session" {
            bind "Alt s" { SwitchToMode "session"; }
        }
        shared_except "locked" "scroll" {
            bind "Ctrl h" { MoveFocusOrTab "left"; }
            bind "Ctrl j" { MoveFocus "down"; }
            bind "Ctrl k" { MoveFocus "up"; }
            bind "Ctrl l" { MoveFocusOrTab "right"; }
            bind "Ctrl 1" { GoToTab 1; }
            bind "Ctrl 2" { GoToTab 2; }
            bind "Ctrl 3" { GoToTab 3; }
            bind "Ctrl 4" { GoToTab 4; }
            bind "Ctrl 5" { GoToTab 5; }
            bind "Ctrl 6" { GoToTab 6; }
            bind "Ctrl 7" { GoToTab 7; }
            bind "Ctrl 8" { GoToTab 8; }
            bind "Ctrl 9" { GoToTab 9; }
            bind "Ctrl 0" { GoToTab 10; }
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
    theme "ayu_dark"
    default_layout "default"
    pane_frames false
    ui {
        pane_frames {
            rounded_corners true
        }
    }
    default_mode "normal"
    plugins {
     autolock location="https://github.com/fresh2dev/zellij-autolock/releases/download/0.2.2/zellij-autolock.wasm"
     triggers  "nvim|vim|vi"
     watch_triggers  "atuin|zoxide|atac"
     watch_interval  1.0
    }
    load_plugins {
        autolock
    }

  '';
  xdg.configFile."zellij/layouts/default.kdl".text = ''
    layout {
              default_tab_template {
              children
                  pane size=1 borderless=true {
                    plugin location="file://${pkgs.zjstatus}/bin/zjstatus.wasm" {
                        format_left   " {mode}#[bg=${colors.bg}] "
                        format_center "{tabs}"
                        format_right  "#[bg=${colors.d_blue},fg=${colors.blue},bold] {session} #[bg=${colors.bg},fg=${colors.d_blue},bold]#[bg=${colors.bg},fg=${colors.blue},bold]  "
                        format_space  ""
                        format_hide_on_overlength "true"
                        format_precedence "crl"

                        border_enabled  "false"
                        border_char     "─"
                        border_format   "#[fg=#6C7086]{char}"
                        border_position "top"

                        mode_normal        "#[bg=${colors.bg},fg=${colors.green},bold] #[bg=${colors.green},fg=${colors.bg},bold] NORMAL#[bg=${colors.bg},fg=${colors.green}]█"
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
              }
              }
  '';

  xdg.configFile."zellij/layouts/default.swap.kdl".text = ''
    tab_template name="ui" {
    children
    pane size=1 borderless=true {
        plugin location="tab-bar" {
            hide_swap_layout_indication true
        }
    }
    }

    swap_tiled_layout name="vertical" {
        ui max_panes=5 {
            pane split_direction="vertical" {
                pane
                pane { children; }
            }
        }
        ui max_panes=8 {
            pane split_direction="vertical" {
                pane { children; }
                pane { pane; pane; pane; pane; }
            }
        }
        ui max_panes=12 {
            pane split_direction="vertical" {
                pane { children; }
                pane { pane; pane; pane; pane; }
                pane { pane; pane; pane; pane; }
            }
        }
    }

    swap_tiled_layout name="horizontal" {
        ui max_panes=5 {
            pane
            pane
        }
        ui max_panes=8 {
            pane {
                pane split_direction="vertical" { children; }
                pane split_direction="vertical" { pane; pane; pane; pane; }
            }
        }
        ui max_panes=12 {
            pane {
                pane split_direction="vertical" { children; }
                pane split_direction="vertical" { pane; pane; pane; pane; }
                pane split_direction="vertical" { pane; pane; pane; pane; }
            }
        }
    }

    swap_tiled_layout name="stacked" {
        ui min_panes=5 {
            pane split_direction="vertical" {
                pane
                pane stacked=true { children; }
            }
        }
    }

    swap_floating_layout name="staggered" {
        floating_panes
    }

    swap_floating_layout name="enlarged" {
        floating_panes max_panes=10 {
            pane { x "5%"; y 1; width "90%"; height "90%"; }
            pane { x "5%"; y 2; width "90%"; height "90%"; }
            pane { x "5%"; y 3; width "90%"; height "90%"; }
            pane { x "5%"; y 4; width "90%"; height "90%"; }
            pane { x "5%"; y 5; width "90%"; height "90%"; }
            pane { x "5%"; y 6; width "90%"; height "90%"; }
            pane { x "5%"; y 7; width "90%"; height "90%"; }
            pane { x "5%"; y 8; width "90%"; height "90%"; }
            pane { x "5%"; y 9; width "90%"; height "90%"; }
            pane { x 10; y 10; width "90%"; height "90%"; }
        }
    }

    swap_floating_layout name="spread" {
        floating_panes max_panes=1 {
            pane {y "50%"; x "50%"; }
        }
        floating_panes max_panes=2 {
            pane { x "1%"; y "25%"; width "45%"; }
            pane { x "50%"; y "25%"; width "45%"; }
        }
        floating_panes max_panes=3 {
            pane { y "55%"; width "45%"; height "45%"; }
            pane { x "1%"; y "1%"; width "45%"; }
            pane { x "50%"; y "1%"; width "45%"; }
        }
        floating_panes max_panes=4 {
            pane { x "1%"; y "55%"; width "45%"; height "45%"; }
            pane { x "50%"; y "55%"; width "45%"; height "45%"; }
            pane { x "1%"; y "1%"; width "45%"; height "45%"; }
            pane { x "50%"; y "1%"; width "45%"; height "45%"; }
        }
    }
  '';

}
