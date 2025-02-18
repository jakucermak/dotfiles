{ config, pkgs, ... }:

let
  colors = {
    green = "#AAD94C";
    orange = "#FFB454";
    d_orange = "#2e210f";
    red = "#F07178";
    yellow = "#F4B664";
    bg = "#0D1017";
    fg = "#BFBDB6";
    blue = "#39BAE6";
    d_blue = "#062b37";
    magenta = "#D2A6FF";
  };

in {
  programs.starship = {
    enable = true;
    enableNushellIntegration = false;
    settings = {
      add_newline = true;
      format =
        "[╭─](${colors.blue}) $username$directory$git_branch$git_status$golang$python$php$nodejs$rust $fill $cmd_duration $line_break[╰──](${colors.blue})$character";
      directory = {
        format =
          "[───](${colors.blue}) [$path]($style)[$read_only]($read_only_style) ";
        style = "bold ${colors.green}";
        truncation_length = 8;
      };
      cmd_duration = {
        disabled = false;
        format = "[took $duration]($style) ";
        style = "${colors.orange}";
      };
      fill = {
        symbol = "─";
        style = "${colors.d_blue}";
      };
      git_branch = {
        format =
          "[───](${colors.blue}) [$symbol $branch(:$remote_branch)]($style) ";
        style = "bold ${colors.magenta}";
        symbol = "";
      };
      git_status = {
        format = "([$all_status$ahead_behind]($style))";
        conflicted = "🤮 ";
        ahead = "👆 ";
        behind = "👇 ";
        diverged = "🚧 ";
        up_to_date = "👍 ";
        untracked = "🔍[($count)](${colors.blue}) ";
        stashed = "📦 ";
        modified = "💩[($count)](${colors.yellow}) ";
        staged = "🚥[($count)](${colors.blue}) ";
        renamed = "👅 ";
        deleted = "🗑 [($count)](${colors.red}) ";
      };
      golang = { format = "[─](${colors.blue}) [$symbol($version)]($style) "; };
      php = {
        format = "[─](${colors.blue}) [$symbol($version)]($style) ";
        symbol = " ";
      };
      python = {
        format =
          "[─](${colors.blue}) [$symbol$pyenv_prefix($version)(( $virtualenv))]($style) ";
      };
      nodejs = { format = "[─](${colors.blue}) [$symbol($version)]($style) "; };
      rust = { format = "[─](${colors.blue}) [$symbol($version)]($style) "; };
      nix_shell = {
        format = "[─](${colors.blue}) [$symbol$state]($style) ";
        symbol = "❄️ ";
      };
      kubernetes = {
        disabled = false;
        format = "[$symbol$context( ($namespace))]($style) ";
      };
      username = {
        show_always = true;
        format = "[$user]($style) ";
        style_user = "bold ${colors.fg}";
      };
      character = { format = "[─❭](${colors.blue}) "; };
    };
  };
}
