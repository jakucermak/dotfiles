{ pkgs, ... }: {

  programs.direnv = { enable = true; };

  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "3ee95536106c11073d6ff466c1681cde31001383";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }
      {
        name = "direnv";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-direnv";
          rev = "0221a4d9080b5f492f1b56ff7b2dc6287f58d47f";
          sha256 = "50tMKwtXtJBpgZ42JfJKyIWgusu4xZ9/yCiGKDfqyhE=";
        };
      }
      {
        name = "ssh_agent";
        src = pkgs.fetchFromGitHub {
          owner = "danhper";
          repo = "fish-ssh-agent";
          rev = "fd70a2afdd03caf9bf609746bf6b993b9e83be57";
          sha256 = "e94Sd1GSUAxwLVVo5yR6msq0jZLOn2m+JZJ6mvwQdLs=";
        };
      }
    ];

    shellAliases = {
      # Git aliases
      gs = "git status";
      ga = "git add";
      gcm = "git commit -m";
      lg = "${pkgs.lazygit}/bin/lazygit";

      # General aliases
      pip = "pip3";
      rr = ". ${pkgs.ranger}/bin/ranger";
      ls = "${pkgs.lsd}/bin/lsd";
      py = "${pkgs.python3}/bin/python3";
      cat = "${pkgs.bat}/bin/bat";
      sw = "telnet towel.blinkenlights.nl";
    };

    shellInit = ''

      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end

      if test -e $HOME/.nix-profile/etc/profile.d/nix.sh
          fenv source $HOME/.nix-profile/etc/profile.d/nix.sh
      end


      set -x PATH $PATH "/usr/local/bin"
      set -x PATH $PATH "/opt/homebrew/bin"
    '';

  };
}
