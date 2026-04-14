{ pkgs, lib, ... }:
let
  tmux-agent-sidebar = pkgs.callPackage ./tmux-agent-sidebar.nix { };
  hookScript = "${tmux-agent-sidebar}/share/tmux-plugins/tmux-agent-sidebar/hook.sh";

  mkHook = arg: {
    matcher = "";
    hooks = [
      {
        type = "command";
        command = ''bash "${hookScript}" claude ${arg}'';
      }
    ];
  };

  osc777Hook = {
    matcher = "";
    hooks = [
      {
        type = "command";
        command = ''
          bash -c '
            input=$(cat)
            title=$(printf "%s" "$input" | ${pkgs.jq}/bin/jq -r ".title // \"Claude Code\"")
            msg=$(printf "%s" "$input" | ${pkgs.jq}/bin/jq -r ".message // \"Task completed\"")
            if [ -n "$TMUX" ]; then
              printf "\033Ptmux;\033\033]777;notify;%s;%s\007\033\\" "$title" "$msg" > /dev/tty
            else
              printf "\033]777;notify;%s;%s\007" "$title" "$msg" > /dev/tty
            fi
          '
        '';
      }
    ];
  };

  hooks = {
    SessionStart = [ (mkHook "session-start") ];
    SessionEnd = [ (mkHook "session-end") ];
    UserPromptSubmit = [ (mkHook "user-prompt-submit") ];
    Notification = [ (mkHook "notification") osc777Hook ];
    Stop = [ (mkHook "stop") ];
    SubagentStart = [ (mkHook "subagent-start") ];
    SubagentStop = [ (mkHook "subagent-stop") ];
    PostToolUse = [ (mkHook "activity-log") ];
  };

  hooksJson = pkgs.writeText "tmux-agent-sidebar-hooks.json" (builtins.toJSON hooks);
in
{
  home.packages = [
    pkgs.claude-code
  ];

  home.activation.tmuxAgentSidebarHooks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings="$HOME/.claude/settings.json"
    mkdir -p "$HOME/.claude"
    if [ ! -f "$settings" ]; then
      echo '{}' > "$settings"
    fi
    tmp=$(${pkgs.coreutils}/bin/mktemp)
    ${pkgs.jq}/bin/jq --slurpfile h ${hooksJson} '.hooks = $h[0]' "$settings" > "$tmp"
    mv "$tmp" "$settings"
  '';
}
