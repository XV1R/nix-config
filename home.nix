# Home Manager configuration for user xavier.
# Runs as a NixOS module: rebuild with `sudo nixos-rebuild switch --flake .#saturn`.
# Never run `home-manager switch` directly.
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./programs/opencode
  ];
  home.username = "xavier";
  home.homeDirectory = "/home/xavier";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # Helix: format Nix buffers with alejandra on save (auto-format on write).
  programs.helix = {
    enable = true;
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter = {
          command = "alejandra";
          args = ["-"];
        };
      }
    ];
  };

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
  };
}
