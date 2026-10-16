# What macOS's own /etc/zshrc, /etc/zprofile and /etc/bashrc did, which
# nix-darwin's generated versions replace.
{
  programs.zsh.interactiveShellInit = ''
    # Correctly display UTF-8 with combining characters
    if [[ ! -x /usr/bin/locale ]] || [[ "$(locale LC_CTYPE)" == "UTF-8" ]]; then
      setopt COMBINING_CHARS
    fi

    # Keep /usr/bin/log reachable instead of zsh's log builtin
    disable log

    # Delete, Home, End and prefix search on Up/Down, from terminfo
    [[ -n $terminfo[kdch1] ]] && bindkey $terminfo[kdch1] delete-char
    [[ -n $terminfo[khome] ]] && bindkey $terminfo[khome] beginning-of-line
    [[ -n $terminfo[kend] ]] && bindkey $terminfo[kend] end-of-line
    [[ -n $terminfo[kcuu1] ]] && bindkey $terminfo[kcuu1] up-line-or-search
    [[ -n $terminfo[kcud1] ]] && bindkey $terminfo[kcud1] down-line-or-search

    # Terminal.app integration (session restore, working directory)
    [ -r "/etc/zshrc_$TERM_PROGRAM" ] && . "/etc/zshrc_$TERM_PROGRAM"
  '';

  # path_helper's /etc/paths(.d) entries (Homebrew, cryptexes, …), appended:
  # path_helper itself would move the system directories ahead of Nix.
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

  # macOS's default prompt, instead of nix-darwin's `prompt suse`
  programs.zsh.promptInit = ''PS1="%n@%m %1~ %# "'';

  # ~/.zshrc runs compinit itself; a second, global one only slows startup.
  # Nix's completion directories stay on fpath either way (/etc/zshenv).
  programs.zsh.enableGlobalCompInit = false;
  programs.zsh.enableBashCompletion = false;

  # macOS's default bash prompt (Home Manager's starship replaces it)
  programs.bash.interactiveShellInit = ''
    PS1='\h:\W \u\$ '
  '';
}
