# Home Manager settings specific to the work Mac, appended in hosts.nix.
{
  programs.helix.settings.theme = "qt_creator_dark";

  # zsh is the login shell here. Home Manager writes ~/.zshenv and ~/.zshrc,
  # so the shared aliases, zoxide, fzf and starship hooks reach zsh too.
  programs.zsh.enable = true;
  # OrbStack (Profound Self Service) maintains this script: it adds
  # ~/.orbstack/bin (docker, kubectl, orb) and completions
  programs.zsh.profileExtra = ''
    source ~/.orbstack/shell/init.zsh 2>/dev/null || :
  '';

  home.shellAliases = {
    ".." = "cd ..";
    g = "git";
    j = "just";
    vim = "nvim";
  };

  # Earlier entries win. Devin (installed through Profound Self Service)
  # and ~/.local/bin came from ~/.zshrc; rustup's ~/.cargo/env added
  # ~/.cargo/bin from ~/.profile and ~/.zshenv.
  home.sessionPath = [
    "$HOME/.codeium/windsurf/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];
}
