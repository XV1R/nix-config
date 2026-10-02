# Home Manager configuration for user xavier.
# Runs as a NixOS module: rebuild with `sudo nixos-rebuild switch --flake .#saturn`.
# Never run `home-manager switch` directly.
{
  config,
  pkgs,
  ...
}: {
  home.username = "xavier";
  home.homeDirectory = "/home/xavier";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # opencode, configured entirely through Home Manager:
  # - context: global rules, written to ~/.config/opencode/AGENTS.md (auto-read by opencode)
  # - agents:  agent definitions, written to ~/.config/opencode/agents/
  programs.opencode = {
    enable = true;
    context = ./opencode/instructions.md;
    agents.nix-coder = ./opencode/agents/nix-coder.md;
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

  home.packages = with pkgs; [ ];
}
