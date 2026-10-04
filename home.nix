# Home Manager configuration for user xavier.
# Runs as a NixOS module: rebuild with `sudo nixos-rebuild switch --flake .#saturn`.
# Never run `home-manager switch` directly.
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./vars.nix
    ./programs/opencode
    ./programs/helix
    ./programs/git
    ./programs/delta
    ./programs/gh
    ./programs/nix-index
    ./programs/jujutsu
    ./programs/machine-report
  ];
  # username/homeDirectory are per-host: set in flake.nix for saturn and the
  # Mac, since the work account name differs.
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # nix-skills: links the skill collection read-only from the Nix store into
  # ~/.config/opencode/skills for opencode's native skill discovery.
  # Note: opencode also reads ~/.claude/skills and ~/.agents/skills, so adding
  # "claude" or "codex" here would duplicate skill names.
  programs.nix-skills = {
    enable = true;
    agents = ["opencode"];
    # skills = [ "nix-language" "nixos-operations" ];  # omit for the full set
  };

  # Manages ~/.bashrc so home.shellAliases and zoxide's shell hook take effect.
  programs.bash.enable = true;

  # System font: Berkeley Mono for the GNOME interface and monospace.
  # GNOME/dconf does not exist on the Mac.
  dconf.settings = lib.mkIf pkgs.stdenv.isLinux {
    "org/gnome/desktop/interface" = {
      font-name = "Berkeley Mono 11";
      monospace-font-name = "Berkeley Mono 11";
    };
  };

  # zoxide needs shell integration; this installs it and sets up the `z` hook.
  programs.zoxide.enable = true;

  home.packages =
    (with pkgs; [
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
      zoxide
    ])
    ++ (
      # v4l2-ctl: scriptable camera controls — Linux-only (video4linux)
      lib.optionals pkgs.stdenv.isLinux (with pkgs; [v4l-utils])
    );

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
