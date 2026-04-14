{ pkgs }:
let
  src = pkgs.fetchFromGitHub {
    owner = "hiroppy";
    repo = "tmux-agent-sidebar";
    rev = "235ceab7ea1cc37efd16b83f57200578cd6b5039";
    hash = "sha256-jyz3uvRgYpI2Wf9FY3jQtXEJEkgzr19a9e387ka8Hlg=";
    name = "tmux-agent-sidebar";
  };

  bin = pkgs.rustPlatform.buildRustPackage {
    pname = "tmux-agent-sidebar";
    version = "unstable-2026-04-14";
    inherit src;
    cargoHash = "sha256-rtjo+zFvSbgB27ZeJNU+9nogmYA2POXlLmWyt1wGbwY=";
    doCheck = false;
  };
in
pkgs.tmuxPlugins.mkTmuxPlugin {
  pluginName = "tmux-agent-sidebar";
  rtpFilePath = "tmux-agent-sidebar.tmux";
  version = "unstable-2026-04-14";
  inherit src;
  postInstall = ''
    mkdir -p $target/bin
    ln -s ${bin}/bin/tmux-agent-sidebar $target/bin/tmux-agent-sidebar
  '';
}
