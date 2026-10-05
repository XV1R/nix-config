# Interactive shells: bash and zsh get the same aliases, PATH and tool
# integrations, whichever one a host's user logs into.
let
  # Home Manager's zsh runs compinit for each user; a global one only adds startup time.
  zsh.programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };
in {
  flake.modules.nixos.shell = zsh;
  flake.modules.darwin.shell = {
    imports = [zsh];

    # What macOS's /etc/zshrc, /etc/zprofile and /etc/bashrc did besides Nix setup
    programs.zsh.interactiveShellInit = ''
      if [[ ! -x /usr/bin/locale ]] || [[ "$(locale LC_CTYPE)" == "UTF-8" ]]; then
        setopt COMBINING_CHARS
      fi
      # Keep /usr/bin/log reachable instead of zsh's log builtin
      disable log
      # Terminal.app integration (session restore, working directory)
      [ -r "/etc/zshrc_$TERM_PROGRAM" ] && . "/etc/zshrc_$TERM_PROGRAM"
    '';
    environment.extraInit = ''
      for f in /etc/paths /etc/paths.d/*; do
        [ -r "$f" ] || continue
        while IFS= read -r p; do
          case ":$PATH:" in
            *":$p:"*) ;;
            *) [ -n "$p" ] && PATH="$PATH:$p" ;;
          esac
        done < "$f"
      done
      unset f p
    '';
    programs.zsh.loginShellInit = ''
      if [ -z "$LANG" ]; then
        export LANG=C.UTF-8
      fi
    '';
    programs.bash.interactiveShellInit = ''
      [ -r "/etc/bashrc_$TERM_PROGRAM" ] && . "/etc/bashrc_$TERM_PROGRAM"
    '';
  };

  flake.modules.homeManager.shell = {pkgs, ...}: {
    programs.bash.enable = true;
    programs.zsh = {
      enable = true;
      history = {
        size = 2000;
        save = 1000;
        share = false;
        ignoreDups = false;
        ignoreSpace = false;
      };
      # Key bindings from macOS's /etc/zshrc, looked up from terminfo
      initContent = ''
        [[ -n $terminfo[kdch1] ]] && bindkey $terminfo[kdch1] delete-char
        [[ -n $terminfo[khome] ]] && bindkey $terminfo[khome] beginning-of-line
        [[ -n $terminfo[kend] ]] && bindkey $terminfo[kend] end-of-line
        [[ -n $terminfo[kcuu1] ]] && bindkey $terminfo[kcuu1] up-line-or-search
        [[ -n $terminfo[kcud1] ]] && bindkey $terminfo[kcud1] down-line-or-search
      '';
    };

    # zoxide's shell hook provides `z` (and the `c` alias below).
    programs.zoxide.enable = true;

    # Ctrl-R history search, Ctrl-T file picker, ** completion
    programs.fzf.enable = true;

    home.sessionPath = ["$HOME/.local/bin"];

    # Tools called by the aliases
    home.packages = with pkgs; [eza procs prettyping glow just];

    home.shellAliases = {
      ".." = "cd ..";
      ls = "eza --group-directories-first";
      l = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
      ps = "procs";
      pgrep = "procs --pgrep";
      ping = "prettyping --nolegend";
      md = "glow";
      c = "z";
      g = "git";
      j = "just";
    };
  };
}
