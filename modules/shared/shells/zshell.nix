{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    completionInit = "";

    # Define zinit instead of oh-my-zsh and zplug

    shellAliases = {
      # Git aliases
      gs = "git status";
      ga = "git add";
      gcm = "git commit -m";
      gp = "git push";
      lg = "${pkgs.lazygit}/bin/lazygit";

      # General aliases
      pip = "pip3";
      ls = "lsd";
      py = "${pkgs.python3}/bin/python3";
      cat = "bat";
      vncviewer = "/Applications/VNC\\ Viewer.app/Contents/MacOS/vncviewer";
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

      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
      alias cd=z

      # zsh-completions must be loaded before compinit. Keep ZLE wrappers
      # synchronous so they cannot redraw over a command line that is being typed.
      zinit light zsh-users/zsh-completions
      zicompinit
      autoload -Uz bashcompinit
      bashcompinit
      zicdreplay

      # Repair shells that sourced an older config where _ssh was a bash-style
      # shim. scp needs zsh's native _ssh for local and remote path completion.
      unfunction _ssh 2>/dev/null || true
      autoload -Uz _ssh
      compdef _ssh ssh scp sftp slogin ssh-add ssh-agent ssh-keygen ssh-keyscan ssh-copy-id

      zinit light zdharma-continuum/fast-syntax-highlighting
      # Avoid ZLE's standout background for bracketed paste without changing
      # fast-syntax-highlighting command/path styles.
      zle_highlight=( ''${(@)zle_highlight:#paste:*} paste:none )
      zinit light zsh-users/zsh-autosuggestions
      unset ZSH_AUTOSUGGEST_USE_ASYNC
      ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
        accept-and-menu-complete
        complete-word
        delete-char-or-list
        expand-or-complete
        expand-or-complete-prefix
        list-choices
        menu-complete
        menu-expand-or-complete
        reverse-menu-complete
      )
      (( $+functions[_zsh_autosuggest_start] )) && _zsh_autosuggest_start
      function _dotfiles_fast_highlight_bracketed_paste() {
        emulate -L zsh
        setopt extendedglob warncreateglobal typesetsilent

        (( ''${+functions[-fast-highlight-init]} && ''${+functions[-fast-highlight-process]} )) || return

        local -a reply
        -fast-highlight-init
        -fast-highlight-process "$PREBUFFER" "$BUFFER" 0
        if (( ''${FAST_HIGHLIGHT[use_brackets]:-0} && ''${+functions[-fast-highlight-string-process]} )); then
          _FAST_MAIN_CACHE=( $reply )
          -fast-highlight-string-process "$PREBUFFER" "$BUFFER"
        fi
        region_highlight=( $reply )
      }

      function _dotfiles_bracketed_paste() {
        local -i retval

        zle _dotfiles_orig_bracketed_paste -- "$@"
        retval=$?
        _dotfiles_fast_highlight_bracketed_paste
        (( ''${+functions[_zsh_autosuggest_highlight_apply]} )) && _zsh_autosuggest_highlight_apply
        zle -R

        return $retval
      }

      if (( ''${+widgets[bracketed-paste]} )); then
        if [[ ''${widgets[bracketed-paste]} != user:_dotfiles_bracketed_paste ]]; then
          zle -A bracketed-paste _dotfiles_orig_bracketed_paste
          zle -N bracketed-paste _dotfiles_bracketed_paste
        fi
        if [[ -z ''${ZSH_AUTOSUGGEST_IGNORE_WIDGETS[(r)bracketed-paste]} ]]; then
          ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(bracketed-paste)
        fi
      fi

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


      # Remove older no-op title hooks from already-running shells when this
      # file is sourced. tmux owns the Ghostty window title now.
      precmd_functions=(''${precmd_functions:#update_tab_title_precmd})
      preexec_functions=(''${preexec_functions:#update_tab_title_preexec})
      unfunction set_tab_title update_tab_title_precmd update_tab_title_preexec 2>/dev/null || true

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

      # Keep scp local file matches ahead of host/user matches. Otherwise names
      # like localhost can stop bare local path completion at a shared prefix.
      zstyle ':completion:*:*:scp:*' tag-order 'files' 'hosts users' '*'

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

      export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
        --color=fg:#bfbdb6,fg+:#d0d0d0,bg:#10141C,bg+:#0D1017
        --color=hl:#39bae6,hl+:#5fd7ff,info:#70bf56,marker:#59c2ff
        --color=prompt:#e6b450,spinner:#d2a6ff,pointer:#d2a6ff,header:#73b8ff
        --color=gutter:#0D1017,border:#1B1F29,label:#aeaeae,query:#d9d9d9
        --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="❭ "
        --marker="❭ " --pointer="▌" --separator="─" --scrollbar="│"'
    '';
  };
}
