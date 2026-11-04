# Rex server for Rex Beta.app on the Mac (Linux Rex is server-only).
# Login-server mode: one root process identifies each caller by their
# Tailscale login and runs a Rex server as the matching account, so sessions
# are xavier's own shell, files, and permissions (the shared mode would run
# everything as a `rex` system account instead).
#
# Reached through Tailscale Serve at https://saturn.<tailnet>.ts.net:7297;
# the Rex client tries 7297 after 443, so the bare hostname is enough in
# "Add Remote Host…". Needs modules/tailscale.nix and the
# rex.nixosModules.default import (both appended in hosts.nix).
# NixOS-level: never import this into darwin.
#
# One-time, imperative setup (like tailscale's in modules/tailscale.nix):
#   rex skill setup --agent opencode   # agent skill stub in ~/.agents/skills/rex
# The stub is versioned by rex and reads its guide from the installed rex at
# runtime, so rex owns that file — don't declare it in home-manager. The
# docs MCP for agents ("superlogical") is declared in modules/opencode.
{
  services.rex.loginServer = {
    enable = true;
    # Fails closed: a principal that doesn't match the real login admits
    # nobody. Confirm the login with
    #   tailscale status --json | jq -r '.User[] | .LoginName'
    accounts.xavier.principals = ["tailscale:XV1R@github"];
    tailscaleServe.enable = true;
  };

  # Rex puts its bin dir first on PATH in its own terminals and exports
  # REX_BIN_DIR, but a fixed NixOS PATH can drop it again. Rex's docs
  # prescribe exactly this restore for interactive shells.
  environment.interactiveShellInit = ''
    if [ -n "$REX_BIN_DIR" ]; then
      export PATH="$REX_BIN_DIR:$PATH"
    fi
  '';
}
