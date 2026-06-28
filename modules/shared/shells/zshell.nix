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

      # Automatically load all .env files in the current directory ancestry and
      # Python .venv from the current directory. .env files are sourced from
      # parent to child so closer directories win on conflicting variables.
      #
      # The hook remembers the shell's original value for every variable declared
      # by a managed .env before the hook first touches it. On every directory
      # change it restores that baseline, then reapplies the active .env stack;
      # moving up or away therefore restores parent/original values instead of
      # leaving stale child values behind.
      typeset -ga _DOTFILES_AUTO_ENV_FILES=()
      typeset -ga _DOTFILES_AUTO_ENV_VARS=()
      typeset -gA _DOTFILES_AUTO_ENV_ORIGINAL_EXISTS=()
      typeset -gA _DOTFILES_AUTO_ENV_ORIGINAL_EXPORTS=()
      typeset -gA _DOTFILES_AUTO_ENV_ORIGINAL_VALUES=()
      typeset -g _DOTFILES_AUTO_VENV=""

      function _dotfiles_env_keys() {
        local env_file="$1"
        [[ -f "$env_file" ]] || return 0

        command sed -nE 's/^[[:space:]]*(export[[:space:]]+)?([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*=.*/\2/p' "$env_file"
      }

      function _dotfiles_find_env_stack() {
        local dir="$PWD"

        reply=()
        while [[ -n "$dir" ]]; do
          [[ -f "$dir/.env" ]] && reply=("$dir/.env" "''${reply[@]}")
          [[ "$dir" == "/" ]] && break
          dir="''${dir:h}"
        done
      }

      function _dotfiles_env_stack_matches() {
        local -a desired_files=("$@")
        local -i index

        (( ''${#desired_files} == ''${#_DOTFILES_AUTO_ENV_FILES} )) || return 1
        for (( index = 1; index <= ''${#desired_files}; index++ )); do
          [[ "''${desired_files[$index]}" == "''${_DOTFILES_AUTO_ENV_FILES[$index]}" ]] || return 1
        done

        return 0
      }

      function _dotfiles_remember_env_var() {
        local key="$1"
        [[ -n "$key" ]] || return 0

        if (( ! ''${+_DOTFILES_AUTO_ENV_ORIGINAL_EXISTS[$key]} )); then
          if (( ''${+parameters[$key]} )); then
            _DOTFILES_AUTO_ENV_ORIGINAL_EXISTS[$key]=1
            _DOTFILES_AUTO_ENV_ORIGINAL_VALUES[$key]="''${(P)key}"
            if [[ "''${parameters[$key]}" == *export* ]]; then
              _DOTFILES_AUTO_ENV_ORIGINAL_EXPORTS[$key]=1
            else
              _DOTFILES_AUTO_ENV_ORIGINAL_EXPORTS[$key]=0
            fi
          else
            _DOTFILES_AUTO_ENV_ORIGINAL_EXISTS[$key]=0
            _DOTFILES_AUTO_ENV_ORIGINAL_EXPORTS[$key]=0
            _DOTFILES_AUTO_ENV_ORIGINAL_VALUES[$key]=""
          fi

          _DOTFILES_AUTO_ENV_VARS+=("$key")
        fi
      }

      function _dotfiles_collect_env_stack_vars() {
        local env_file key
        local -a env_vars

        reply=()
        for env_file in "$@"; do
          env_vars=( ''${(@f)$(_dotfiles_env_keys "$env_file")} )
          for key in "''${env_vars[@]}"; do
            [[ -n "$key" ]] || continue
            _dotfiles_remember_env_var "$key"
            [[ -z "''${reply[(r)$key]}" ]] && reply+=("$key")
          done
        done
      }

      function _dotfiles_restore_managed_env() {
        local key

        for key in "''${_DOTFILES_AUTO_ENV_VARS[@]}"; do
          if [[ "''${_DOTFILES_AUTO_ENV_ORIGINAL_EXISTS[$key]}" == 1 ]]; then
            typeset -g -- "$key=''${_DOTFILES_AUTO_ENV_ORIGINAL_VALUES[$key]}"
            if [[ "''${_DOTFILES_AUTO_ENV_ORIGINAL_EXPORTS[$key]}" == 1 ]]; then
              export "$key"
            else
              typeset +x "$key" 2>/dev/null || true
            fi
          else
            unset "$key"
          fi
        done
      }

      function _dotfiles_source_env_stack() {
        local env_file
        local -i allexport_was_set=0
        local -i retval=0

        [[ -o allexport ]] && allexport_was_set=1
        set -a
        for env_file in "$@"; do
          source "$env_file" || retval=$?
        done
        if (( allexport_was_set )); then
          set -a
        else
          set +a
        fi

        return $retval
      }

      function _dotfiles_set_dotenv_file_marker() {
        local -a env_files=("$@")
        local IFS=:

        if (( ''${#env_files} )); then
          export DOTFILES_DOTENV_FILE="''${env_files[*]}"
        else
          unset DOTFILES_DOTENV_FILE
        fi
      }

      function _dotfiles_reload_env_stack() {
        local -a env_files=("$@")
        local -i retval=0

        _dotfiles_collect_env_stack_vars "''${env_files[@]}"
        _dotfiles_restore_managed_env
        if (( ''${#env_files} )); then
          _dotfiles_source_env_stack "''${env_files[@]}" || retval=$?
        fi

        _DOTFILES_AUTO_ENV_FILES=("''${env_files[@]}")
        _dotfiles_set_dotenv_file_marker "''${env_files[@]}"

        return $retval
      }

      function _dotfiles_deactivate_venv() {
        if [[ -n "$_DOTFILES_AUTO_VENV" && "''${VIRTUAL_ENV:-}" == "$_DOTFILES_AUTO_VENV" ]]; then
          if (( ''${+functions[deactivate]} )); then
            deactivate
          else
            unset VIRTUAL_ENV VIRTUAL_ENV_PROMPT
          fi
        fi
        _DOTFILES_AUTO_VENV=""
      }

      function _dotfiles_activate_venv() {
        local venv_dir="$1"
        [[ -f "$venv_dir/bin/activate" ]] || return 0

        source "$venv_dir/bin/activate"
        _DOTFILES_AUTO_VENV="$venv_dir"
      }

      function _dotfiles_auto_project_env() {
        local -a env_files
        local venv_dir="$PWD/.venv"

        _dotfiles_find_env_stack
        env_files=("''${reply[@]}")

        if ! _dotfiles_env_stack_matches "''${env_files[@]}"; then
          _dotfiles_reload_env_stack "''${env_files[@]}"
        fi

        if [[ "$venv_dir" != "$_DOTFILES_AUTO_VENV" ]]; then
          _dotfiles_deactivate_venv
          [[ -f "$venv_dir/bin/activate" ]] && _dotfiles_activate_venv "$venv_dir"
        fi
      }

      autoload -Uz add-zsh-hook
      add-zsh-hook chpwd _dotfiles_auto_project_env
      _dotfiles_auto_project_env

      # Starship custom modules cannot read the previous command status directly.
      # Capture it before Starship's precmd hook renders the prompt, then return
      # it so later precmd hooks still see the original exit code.
      typeset -gi DOTFILES_STARSHIP_EXIT_CODE=0

      function _dotfiles_capture_starship_exit_code() {
        local -i exit_code=$?
        DOTFILES_STARSHIP_EXIT_CODE=$exit_code
        export DOTFILES_STARSHIP_EXIT_CODE
        return $exit_code
      }

      precmd_functions=(
        _dotfiles_capture_starship_exit_code
        ''${precmd_functions:#_dotfiles_capture_starship_exit_code}
      )

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
