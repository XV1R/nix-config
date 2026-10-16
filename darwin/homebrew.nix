# Homebrew stays available for tools Nix doesn't provide. This replaces
# `brew shellenv`, which would put Homebrew ahead of Nix: its directories
# come after the Nix profiles (order 1000) and before the macOS system
# directories (order 1200), so Nix wins for anything installed by both.
{
  lib,
  macUser,
  ...
}: {
  # nix-homebrew pins brew itself. On first activation it deletes the
  # existing /opt/homebrew git checkout of Homebrew, keeping installed
  # packages and taps.
  nix-homebrew = {
    enable = true;
    user = macUser;
    autoMigrate = true;
    # These run `brew shellenv`, which puts Homebrew ahead of Nix
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
  };

  # Only what Nix can't provide. Activation runs `brew bundle` without
  # updating or upgrading; run `brew upgrade` yourself to update these.
  # Declared formulae and casks are trusted individually, not their taps.
  homebrew = {
    enable = true;
    taps = ["can1357/tap" "hewigovens/tap" "superhq-ai/tap"];
    brews = [
      "herdr"
      "humanlog"
      "can1357/tap/omp"
    ];
    casks = [
      "hewigovens/tap/jayjay"
      "superhq-ai/tap/superhq"
    ];
  };

  environment.systemPath = lib.mkOrder 1100 ["/opt/homebrew/bin" "/opt/homebrew/sbin"];

  # The rest of what `brew shellenv` sets up. HOMEBREW_REPOSITORY is left
  # to nix-homebrew's brew, which sets it to its own fake repository.
  environment.variables = {
    HOMEBREW_PREFIX = "/opt/homebrew";
    HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
    INFOPATH = "/opt/homebrew/share/info:";
  };
  # Completions for Homebrew-installed tools; /etc/zshrc runs before the
  # compinit in ~/.zshrc
  programs.zsh.interactiveShellInit = "fpath=(/opt/homebrew/share/zsh/site-functions $fpath)";
}
