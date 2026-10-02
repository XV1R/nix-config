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

  # nix-skills: links the skill collection read-only from the Nix store into
  # ~/.config/opencode/skills for opencode's native skill discovery.
  # Note: opencode also reads ~/.claude/skills and ~/.agents/skills, so adding
  # "claude" or "codex" here would duplicate skill names.
  programs.nix-skills = {
    enable = true;
    agents = ["opencode"];
    # skills = [ "nix-language" "nixos-operations" ];  # omit for the full set
  };

  # opencode is customized here; nothing under ~/.config/opencode is edited by hand.
  xdg.configFile = {
    "opencode/agent/nix-coder.md".source = ./opencode/agents/nix-coder.md;
    "opencode/instructions.md".source = ./opencode/instructions.md;
    "opencode/opencode.json".text = builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      instructions = [ "/home/xavier/.config/opencode/instructions.md" ];
    } + "\n";
  };

  home.packages = with pkgs; [ ];
}
