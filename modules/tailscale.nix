# Tailscale: saturn's private network for personal services (Rex, Miniflux).
# Services are published to the tailnet with Tailscale Serve, which runs
# inside tailscaled, so no LAN firewall ports are opened for them.
#
# One-time, imperative setup (tailscaled keeps it in /var/lib/tailscale):
#   sudo tailscale up            # log in; enrolls saturn in the tailnet
#   tailscale status --json | jq -r '.User[] | .LoginName'   # your login
# Then turn on MagicDNS and HTTPS certificates in the admin console
# (DNS page), which Serve needs for https://saturn.<tailnet>.ts.net.
# NixOS-level: never import this into darwin.
{
  services.tailscale = {
    enable = true;
    # UDP 41641 for direct peer connections instead of DERP relays.
    openFirewall = true;
  };
}
