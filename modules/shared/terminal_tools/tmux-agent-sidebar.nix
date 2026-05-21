{ pkgs }:
let
  src = pkgs.fetchFromGitHub {
    owner = "hiroppy";
    repo = "tmux-agent-sidebar";
    rev = "e1bfb986f53cf860a9be98f661052ca095c03d84";
    hash = "sha256-OFSeoPwtJ3Dc9J1VCZIaXt+f4XC9Cb/qDjlxnVa3cK4=";
    name = "tmux-agent-sidebar";
  };

  bin = pkgs.rustPlatform.buildRustPackage {
    pname = "tmux-agent-sidebar";
    version = "unstable-2026-04-14";
    inherit src;
    cargoHash = "sha256-a03IQg9koeIv6OpaGGtCb0OB9G5+UYmZUC+ZtLXr3us=";
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
