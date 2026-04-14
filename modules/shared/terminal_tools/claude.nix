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

  hooks = {
    SessionStart = [ (mkHook "session-start") ];
    SessionEnd = [ (mkHook "session-end") ];
    UserPromptSubmit = [ (mkHook "user-prompt-submit") ];
    Notification = [ (mkHook "notification") ];
    Stop = [ (mkHook "stop") ];
    StopFailure = [ (mkHook "stop-failure") ];
    PermissionDenied = [ (mkHook "permission-denied") ];
    CwdChanged = [ (mkHook "cwd-changed") ];
    SubagentStart = [ (mkHook "subagent-start") ];
    SubagentStop = [ (mkHook "subagent-stop") ];
    PostToolUse = [ (mkHook "activity-log") ];
    TaskCreated = [ (mkHook "task-created") ];
    TaskCompleted = [ (mkHook "task-completed") ];
    TeammateIdle = [ (mkHook "teammate-idle") ];
    WorktreeCreate = [ (mkHook "worktree-create") ];
    WorktreeRemove = [ (mkHook "worktree-remove") ];
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
