# Global development tools for the work Mac. Language runtimes and
# libraries belong in each project's devenv.nix instead.
{
  inputs,
  lib,
  pkgs,
  ...
}: let
  # Tools that release faster than a stable nixpkgs branch keeps up with.
  # Imported rather than legacyPackages so claude-code (unfree) is allowed,
  # by name only.
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfreePredicate = p: lib.getName p == "claude-code";
  };

  # pi shells out to npm for `pi install` and `pi update`. Appended, so a
  # project's own Node still wins inside its devenv.
  pi = pkgs.symlinkJoin {
    name = "pi-with-npm";
    paths = [unstable.pi-coding-agent];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/pi --suffix PATH : ${lib.makeBinPath [unstable.nodejs]}
    '';
  };
in {
  home.packages = with pkgs; [
    cmake
    codex # OpenAI Codex CLI
    alejandra # Nix formatter
    nil # Nix language server
    # GNU coreutils as gls, gdate, …, leaving macOS's BSD tools in place
    coreutils-prefixed
    unstable.mise
    pi
    unstable.claude-code
    unstable.mcp-nixos # pi's nixos MCP server (~/.pi/agent/mcp.json)
  ];
}
