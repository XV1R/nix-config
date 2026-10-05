# Homebrew stays available for tools Nix doesn't manage. Its directories
# come after the Nix profiles (order 1000) and before the macOS system
# directories (order 1200), so Nix wins for anything installed by both.
{
  flake.modules.darwin.homebrew = {lib, ...}: {
    environment.systemPath = lib.mkOrder 1100 ["/opt/homebrew/bin" "/opt/homebrew/sbin"];

    # The rest of what `brew shellenv` sets up
    environment.variables = {
      HOMEBREW_PREFIX = "/opt/homebrew";
      HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
      HOMEBREW_REPOSITORY = "/opt/homebrew";
      INFOPATH = "/opt/homebrew/share/info:";
    };
    # Completions for Brew-installed tools; /etc/zshrc runs before each user's compinit
    programs.zsh.interactiveShellInit = "fpath=(/opt/homebrew/share/zsh/site-functions $fpath)";
  };
}
