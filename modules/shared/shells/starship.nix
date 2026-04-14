{ ... }:

let
  colors = {
    green = "#AAD94C";
    orange = "#E6B450";
    d_orange = "#2e210f";
    red = "#F07178";
    yellow = "#F4B664";
    bg = "#0D1017";
    fg = "#BFBDB6";
    blue = "#39BAE6";
    d_blue = "#062b37";
    magenta = "#D2A6FF";
  };

in
{
  programs.starship = {
    enable = true;
    enableNushellIntegration = false;
    settings = {
      add_newline = false;
      format = "$username$directory$git_branch$git_status$golang$python$php$nodejs$rust(${colors.orange})$character";
      directory = {
        format = "[$path]($style)[$read_only]($read_only_style) ";
        style = "bold ${colors.green}";
        truncation_length = 2;
      };
      cmd_duration = {
        disabled = false;
        format = "[took $duration]($style) ";
        style = "${colors.orange}";
      };

      git_branch = {
        format = "[─](${colors.blue}) [$symbol $branch(:$remote_branch)]($style) ";
        style = "bold ${colors.magenta}";
        symbol = "";
      };
      golang = {
        format = "[─](${colors.blue}) [$symbol($version)]($style) ";
      };
      php = {
        format = "[─](${colors.blue}) [$symbol($version)]($style) ";
        symbol = " ";
      };
      python = {
        format = "[─](${colors.blue}) [$symbol$pyenv_prefix($version)(( $virtualenv))]($style) ";
      };
      nodejs = {
        format = "[─](${colors.blue}) [$symbol($version)]($style) ";
      };
      rust = {
        format = "[─](${colors.blue}) [$symbol($version)]($style) ";
      };
      nix_shell = {
        format = "[─](${colors.blue}) [$symbol$state]($style) ";
        symbol = "❄️ ";
      };
      kubernetes = {
        disabled = false;
        format = "[$symbol$context( ($namespace))]($style) ";
      };
      username = {
        show_always = false;
        format = "[$user]($style) [─](${colors.blue}) ";
        style_user = "bold ${colors.fg}";
      };
      character = {
        format = "[❭](${colors.blue}) ";
      };
    };
  };
}
