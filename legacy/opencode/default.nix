{lib, ...}: {
  # - context: global rules, written to ~/.config/opencode/AGENTS.md (auto-read by opencode)
  # - agents:  agent definitions, written to ~/.config/opencode/agents/
  programs.opencode = {
    enable = true;
    context = ./instructions.md;
    agents.nix-coder = ./agents/nix-coder.md;
    # Format Nix files after the agent edits them
    settings.formatter.nix = {
      command = ["alejandra"];
      extensions = [".nix"];
    };
  };
}
