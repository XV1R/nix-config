# Home Manager base configuration, shared by every host in hosts.nix.
# Strictly cross-platform: anything host-specific or platform-specific
# lives in its own module under modules/ and is appended per host.
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./vars.nix
    ./modules/nix-skills.nix
    ./modules/nix-index.nix
    ./modules/opencode
    ./modules/helix
    ./modules/git
    ./modules/delta
    ./modules/gh
    ./modules/jujutsu
    # Per-host modules (walker, gnome, machine-report, …) are appended in
    # hosts.nix via extraModules.
  ];
  # username/homeDirectory are per-host: set in hosts.nix for saturn and the
  # Mac, since the work account name differs.
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # Manages ~/.bashrc so home.shellAliases and zoxide's shell hook take effect.
  programs.bash.enable = true;

  # zoxide needs shell integration; this installs it and sets up the `z` hook.
  programs.zoxide.enable = true;

  home.packages = with pkgs; [
    eza
    fd
    dust
    just
    jq
    btop
    procs
    prettyping
    tokei
    glow
    statix # nix linter; alejandra formats, statix finds antipatterns
    hax # oneshot agent (hax -p "…"), built via overlay from packages/hax.nix
    zoxide
    ghostty
    # Per-app entries like discord/steam/prismlauncher are NOT here: they
    # live in modules/ and are appended per host in hosts.nix.
  ];

  home.shellAliases = {
    ls = "eza --group-directories-first";
    l = "eza -l";
    la = "eza -la";
    lt = "eza --tree";
    ps = "procs";
    pgrep = "procs --pgrep";
    ping = "prettyping --nolegend";
    md = "glow";
    c = "z";
  };
}
