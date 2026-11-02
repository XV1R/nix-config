# Miniflux RSS reader, with a local PostgreSQL the module provisions.
# Listens on localhost:8080 only.
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
  services.miniflux = {
    enable = true;
    # A string, not a Nix path: a path literal would copy the secret into
    # the store.
    adminCredentialsFile = "/etc/miniflux/admin-credentials";
    config.LISTEN_ADDR = "127.0.0.1:8080";
  };
}
