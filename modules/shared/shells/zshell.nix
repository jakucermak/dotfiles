{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    # Define zinit instead of oh-my-zsh and zplug

    shellAliases = {
      # Git aliases
      gs = "git status";
      ga = "git add";
      gcm = "git commit -m";
      lg = "${pkgs.lazygit}/bin/lazygit";

      # General aliases
      pip = "pip3";
      ls = "lsd";
      py = "${pkgs.python3}/bin/python3";
      cat = "bat";
      vncviewer = "/Applications/VNC\\ Viewer.app/Contents/MacOS/vncviewer";
      zj = "${pkgs.zellij}/bin/zellij";
    };

    initContent = ''
      # Install zinit if not present
      ZINIT_HOME="$HOME/.zinit"
      if [ ! -d "$ZINIT_HOME" ]; then
        mkdir -p "$ZINIT_HOME"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME/bin"
      fi

      # Load zinit
      source "$ZINIT_HOME/bin/zinit.zsh"

      # Load essential plugins instantly
      zinit light zsh-users/zsh-autosuggestions

      # Load less critical plugins in turbo mode (asynchronously)
      zinit wait lucid for \
        atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
        atload"_zsh_autosuggest_start" \
        zsh-users/zsh-completions

      # Load git and npm functionality in turbo mode
      zinit wait lucid for \
        OMZL::git.zsh \
        OMZP::git/git.plugin.zsh

      zinit wait lucid for \
        OMZP::npm/npm.plugin.zsh

      # Lazy load tools
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"

      alias cd=z

      function fzf-loader() {
        eval "$(fzf --zsh)"
        zle fzf-history-widget
      }
      zle -N fzf-loader
      bindkey '^R' fzf-loader

      function pyenv-loader() {
        eval "$(pyenv init - zsh)"
        unfunction pyenv-loader
        pyenv "$@"
      }
      alias pyenv="pyenv-loader"

      # Lazy load gcloud
      function gcloud() {
        local gcloud_sdk_path='/Users/jakubcermak/Downloads/google-cloud-sdk'
        if [ -f "$gcloud_sdk_path/path.zsh.inc" ]; then
          source "$gcloud_sdk_path/path.zsh.inc"
        fi
        if [ -f "$gcloud_sdk_path/completion.zsh.inc" ]; then
          source "$gcloud_sdk_path/completion.zsh.inc"
        fi
        unfunction gcloud
        command gcloud "$@"
      }

      # Zellij tab title management - moved to a more efficient implementation
      if [[ -n $ZELLIJ ]]; then
        autoload -Uz add-zsh-hook

        function set_tab_title() {
          local cmd="$1"
          local title

          if [[ -z "$cmd" || "$cmd" == "" ]]; then
            # Use directory name for empty command (precmd)
            title="$PWD"
            title="''${title/#$HOME/~}"
            title="''${title##*/}"
          else
            # Use first word of command
            title="''${cmd%% *}"
            # Extract hostname for ssh commands
            if [[ "$title" == "ssh" ]]; then
              title="''${cmd#ssh }"
              title="''${title%% *}"
            fi
          fi

          command nohup ${pkgs.zellij}/bin/zellij action rename-tab "$title" >/dev/null 2>&1
        }

        function update_tab_title_precmd() {
          set_tab_title ""
        }

        function update_tab_title_preexec() {
          set_tab_title "$1"
        }

        add-zsh-hook precmd update_tab_title_precmd
        add-zsh-hook preexec update_tab_title_preexec
      fi

      # VNC viewer setup
      vncparams=(
        "-ColorLevel=full"
        "-WarnUnencrypted=0"
        "-SendSpecialKeys=0"
        "-Scaling=AspectFit"
      )

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


      function hugvnc() {
        /Applications/VNC\ Viewer.app/Contents/MacOS/vncviewer "$1" ''${vncparams[@]} -passwordFile ~/passwd
      }
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

      export PATH="$HOME/.pyenv/bin:$PATH"
      export PYENV_ROOT="$HOME/.pyenv"
      [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

      export PATH="/opt/homebrew/opt/ansible@9/bin:$PATH"
      export PATH="$HOME/.cargo/bin:$PATH"
      export PATH="${pkgs.zellij}/bin:$PATH"

      export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color=fg:#bfbdb6,bg:#10141C,hl:#39bae6 --color=fg+:#bfbdb6,bg+:#0d1017,hl+:#5fd7ff --color=info:#70bf56,prompt:#e6b450,pointer:#d2a6ff --color=marker:#59c2ff,spinner:#d2a6ff,header:#73b8ff'
    '';
  };
}
