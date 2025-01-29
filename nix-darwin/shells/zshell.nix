{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "npm" ];
    };

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        {
          name = "zsh-users/zsh-syntax-highlighting";
        } # Simple plugin installation
      ];
    };

    shellAliases = {
      # Git aliases
      gs = "git status";
      ga = "git add";
      gcm = "git commit -m";

      # General aliases
      pip = "pip3";
      rr = ". ranger";
      ls = "lsd";
      py = "python3";
      ssh = "TERM=xterm-256color ssh";
      cat = "bat";
      sw = "telnet towel.blinkenlights.nl";

      # Conditional aliases are handled in initExtra
    };

    initExtra = ''
      alias vncviewer="/Applications/VNC\ Viewer.app/Contents/MacOS/vncviewer";

      # VNC viewer setup
      vncparams=(
        "-ColorLevel=full"
        "-WarnUnencrypted=0"
        "-SendSpecialKeys=0"
        "-Scaling=AspectFit"
      )

      function hugvnc() {
        echo ''${vncparams[@]}
        vncviewer "$1" ''${vncparams[@]} -passwordFile ~/passwd
      }

      # Functions
      function catdiff() {
        git diff --name-only --relative --diff-filter=d | xargs bat --diff
      }

      function mkcd() {
        mkdir -p "$@" && cd "$_";
      }

      # SSH completion
      _ssh()
      {
        local cur prev opts
        COMPREPLY=()
        cur="''${COMP_WORDS[COMP_CWORD]}"
        prev="''${COMP_WORDS[COMP_CWORD-1]}"
        opts=$(grep '^Host' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null | grep -v '[?*]' | cut -d ' ' -f 2-)

        COMPREPLY=( $(compgen -W "$opts" -- ''${cur}) )
        return 0
      }
      complete -F _ssh ssh

      # Initialize tools
      eval "$(starship init zsh)"
      eval "$(zoxide init zsh)"
      eval "$(fzf --zsh)"

    '';

    envExtra = ''
      export PATH=$PATH:~/.local/bin
      export ANSIBLE_CONFIG=~/.ansible/ansible.cfg

      # pnpm
      export PNPM_HOME="/Users/jakubcermak/Library/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac

      export PATH="/opt/homebrew/opt/ansible@9/bin:$PATH"
      export PATH="$HOME/.cargo/bin:$PATH"

    '';
  };

  # Required packages
  home.packages = with pkgs; [
    bat
    lsd
    fzf
    zoxide
    ranger
    python3
    tree
    ripgrep-all
    bottom
    curl
    rustup
    python312
    python312Packages.ansible-core
    ansible-lint
    bottom
  ];
}
