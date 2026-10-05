{inputs, ...}: {
  flake.modules.homeManager.nix-skills = {
    # nix-skills: links the skill collection read-only from the Nix store into
    # ~/.config/opencode/skills for opencode's native skill discovery.
    # Note: opencode also reads ~/.claude/skills and ~/.agents/skills, so adding
    # "claude" or "codex" here would duplicate skill names.
    imports = [inputs.nix-skills.homeManagerModules.default];

    programs.nix-skills = {
      enable = true;
      agents = ["opencode"];
      # skills = [ "nix-language" "nixos-operations" ];  # omit for the full set
    };
  };
}
