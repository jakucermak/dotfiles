{ pkgs }:

pkgs.fetchFromGitHub {
  owner = "hiroppy";
  repo = "tmux-agent-sidebar";
  rev = "e1bfb986f53cf860a9be98f661052ca095c03d84";
  hash = "sha256-OFSeoPwtJ3Dc9J1VCZIaXt+f4XC9Cb/qDjlxnVa3cK4=";
  name = "tmux-agent-sidebar";
}
