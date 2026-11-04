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
    # Rex community MCP: Rex docs, changelog, and Beta Discord archive
    # search for agents (read-only). OAuth 2.1 via Discord — opencode
    # auto-detects it; first use opens a browser sign-in (Rex Beta Discord
    # members only). Named "superlogical" per Rex's own recommendation,
    # so it can't collide with rex skills or the CLI.
    settings.mcp.superlogical = {
      type = "remote";
      url = "https://www.superlogical.com/rex/community-mcp";
      enabled = true;
    };
  };
}
