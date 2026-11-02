# Miniflux RSS reader, with a local PostgreSQL the module provisions.
# Listens on localhost:8080 only; Tailscale Serve publishes it to the tailnet
# at https://saturn.<tailnet>.ts.net (port 443; Rex's Serve uses 7297).
#
# The admin account comes from a credentials file kept out of the Nix store
# (the store is world-readable). Create it once on saturn before switching:
#   sudo install -d -m 700 /etc/miniflux
#   sudo install -m 600 /dev/stdin /etc/miniflux/admin-credentials <<'EOF'
#   ADMIN_USERNAME=xavier
#   ADMIN_PASSWORD=<at least 6 characters>
#   EOF
# Miniflux creates the admin only if it doesn't exist yet; later password
# changes happen in the web UI, not here.
# NixOS-level: never import this into darwin.
{
  config,
  lib,
  ...
}: let
  tailscale = lib.getExe config.services.tailscale.package;
in {
  services.miniflux = {
    enable = true;
    # A string, not a Nix path: a path literal would copy the secret into
    # the store.
    adminCredentialsFile = "/etc/miniflux/admin-credentials";
    config.LISTEN_ADDR = "127.0.0.1:8080";
  };

  # Serve mappings live in tailscaled's state; this unit owns the 443 one,
  # adding it on start and removing it on stop, like Rex's
  # rex-tailscale-serve unit does for 7297.
  systemd.services.miniflux-tailscale-serve = {
    description = "Miniflux Tailscale Serve";
    after = ["tailscaled.service" "miniflux.service"];
    requires = ["tailscaled.service" "miniflux.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # Blocks until tailscaled is logged in and running.
      ExecStartPre = "${tailscale} wait";
      ExecStart = "${tailscale} serve --bg --https=443 http://${config.services.miniflux.config.LISTEN_ADDR}";
      ExecStop = "${tailscale} serve --https=443 off";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
