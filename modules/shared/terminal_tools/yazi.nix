{ ... }:
let
  # Ayu dark palette used by the terminal configs in this repository.
  ayuDark = {
    background = "#10141C";
    foreground = "#BFBDB6";
    accent = "#E6B450";
    black = "#5A6673";
    red = "#E6495A";
    green = "#97C142";
    yellow = "#E89D37";
    blue = "#17ACF2";
    magenta = "#C385FE";
    cyan = "#84CEB5";
    white = "#FFFFFF";
    brightRed = "#F07178";
    brightYellow = "#FFB454";
    brightBlue = "#59C2FF";
    brightMagenta = "#D2A6FF";
    brightCyan = "#95E6CB";
  };
in
{
  programs.yazi = {
    enable = true;

    # Home Manager's shell wrapper uses `yazi --cwd-file`, then cds the
    # interactive shell to the directory where Yazi exited. Use the real command
    # name so typing `yazi` has the expected cwd-on-quit behavior.
    shellWrapperName = "yazi";
    enableZshIntegration = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableNushellIntegration = false;

    settings = {
      mgr = {
        ratio = [
          1
          4
          3
        ];
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        show_hidden = true;
        show_symlink = true;
        linemode = "mtime";
      };

      preview = {
        wrap = "no";
        tab_size = 2;
        max_width = 1000;
        max_height = 1600;
      };

      opener.extract = [
        {
          run = "ya pub extract --list %s";
          desc = "Extract here";
        }
      ];
    };

    theme = {
      app.overall = {
        fg = ayuDark.foreground;
        bg = ayuDark.background;
      };

      mgr = {
        cwd = {
          fg = ayuDark.accent;
          bold = true;
        };
        find_keyword = {
          fg = ayuDark.brightYellow;
          bold = true;
          italic = true;
          underline = true;
        };
        find_position = {
          fg = ayuDark.brightMagenta;
          bg = ayuDark.background;
          bold = true;
          italic = true;
        };
        symlink_target = {
          fg = ayuDark.cyan;
          italic = true;
        };
        marker_copied = {
          fg = ayuDark.green;
          bg = ayuDark.green;
        };
        marker_cut = {
          fg = ayuDark.red;
          bg = ayuDark.red;
        };
        marker_marked = {
          fg = ayuDark.cyan;
          bg = ayuDark.cyan;
        };
        marker_selected = {
          fg = ayuDark.accent;
          bg = ayuDark.accent;
        };
        count_copied = {
          fg = ayuDark.background;
          bg = ayuDark.green;
        };
        count_cut = {
          fg = ayuDark.white;
          bg = ayuDark.red;
        };
        count_selected = {
          fg = ayuDark.background;
          bg = ayuDark.accent;
        };
        border_symbol = "│";
        border_style.fg = ayuDark.black;
      };

      tabs = {
        active = {
          fg = ayuDark.background;
          bg = ayuDark.accent;
          bold = true;
        };
        inactive = {
          fg = ayuDark.foreground;
          bg = ayuDark.black;
        };
        sep_inner = {
          open = "";
          close = "";
        };
        sep_outer = {
          open = "";
          close = "";
        };
      };

      mode = {
        normal_main = {
          fg = ayuDark.background;
          bg = ayuDark.accent;
          bold = true;
        };
        normal_alt = {
          fg = ayuDark.accent;
          bg = ayuDark.black;
        };
        select_main = {
          fg = ayuDark.background;
          bg = ayuDark.blue;
          bold = true;
        };
        select_alt = {
          fg = ayuDark.brightBlue;
          bg = ayuDark.black;
        };
        unset_main = {
          fg = ayuDark.white;
          bg = ayuDark.red;
          bold = true;
        };
        unset_alt = {
          fg = ayuDark.brightRed;
          bg = ayuDark.black;
        };
      };

      indicator = {
        parent.reversed = true;
        current = {
          fg = ayuDark.background;
          bg = ayuDark.accent;
          bold = true;
        };
        preview = {
          fg = ayuDark.accent;
          underline = true;
        };
        padding = {
          open = "";
          close = "";
        };
      };

      status = {
        overall = {
          fg = ayuDark.foreground;
          bg = ayuDark.background;
        };
        sep_left = {
          open = "";
          close = "";
        };
        sep_right = {
          open = "";
          close = "";
        };
        perm_sep.fg = ayuDark.black;
        perm_type.fg = ayuDark.green;
        perm_read.fg = ayuDark.yellow;
        perm_write.fg = ayuDark.red;
        perm_exec.fg = ayuDark.cyan;
        progress_label.bold = true;
        progress_normal = {
          fg = ayuDark.green;
          bg = ayuDark.black;
        };
        progress_error = {
          fg = ayuDark.yellow;
          bg = ayuDark.red;
        };
      };

      which = {
        cols = 3;
        mask.bg = ayuDark.background;
        cand.fg = ayuDark.brightCyan;
        rest.fg = ayuDark.black;
        desc.fg = ayuDark.brightMagenta;
        separator = " › ";
        separator_style.fg = ayuDark.black;
      };

      confirm = {
        border.fg = ayuDark.accent;
        title.fg = ayuDark.accent;
        btn_yes.reversed = true;
      };

      spot = {
        border.fg = ayuDark.accent;
        title.fg = ayuDark.accent;
        tbl_col.fg = ayuDark.blue;
        tbl_cell = {
          fg = ayuDark.yellow;
          reversed = true;
        };
      };

      notify = {
        title_info.fg = ayuDark.green;
        title_warn.fg = ayuDark.yellow;
        title_error.fg = ayuDark.red;
      };

      pick = {
        border.fg = ayuDark.accent;
        active = {
          fg = ayuDark.brightMagenta;
          bold = true;
        };
      };

      input = {
        border.fg = ayuDark.accent;
        selected.reversed = true;
      };

      cmp = {
        border.fg = ayuDark.accent;
        active.reversed = true;
      };

      tasks = {
        border.fg = ayuDark.accent;
        hovered = {
          fg = ayuDark.brightMagenta;
          bold = true;
        };
      };

      help = {
        on.fg = ayuDark.brightCyan;
        run.fg = ayuDark.brightMagenta;
        hovered = {
          reversed = true;
          bold = true;
        };
        footer = {
          fg = ayuDark.background;
          bg = ayuDark.foreground;
        };
      };

      filetype.rules = [
        {
          mime = "image/*";
          fg = ayuDark.yellow;
        }
        {
          mime = "{audio,video}/*";
          fg = ayuDark.magenta;
        }
        {
          mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
          fg = ayuDark.red;
        }
        {
          mime = "application/{pdf,doc,rtf}";
          fg = ayuDark.cyan;
        }
        {
          mime = "vfs/{absent,stale}";
          fg = ayuDark.black;
        }
        {
          url = "*";
          is = "orphan";
          bg = ayuDark.red;
        }
        {
          url = "*";
          is = "exec";
          fg = ayuDark.green;
        }
        {
          url = "*/";
          fg = ayuDark.blue;
          bold = true;
        }
      ];
    };
  };
}
