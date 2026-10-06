# Host side of the MicroVM setup (saturn runs the VMs).
# Guests live in ./<name>/ and are declared fully declaratively here.
# VM ports can also be exposed to remote friends over iroh (dumbpipe),
# see the "Remote access" section below.
{
  inputs,
  pkgs,
  ...
}: {
  microvm.vms.minecraft = {
    specialArgs = {inherit inputs;};
    # null = instantiate the guest's own package set, so the guest's
    # nixpkgs.overlays (nix-minecraft) and allowUnfree actually apply.
    pkgs = null;
    config = import ./minecraft;
  };

  # ~/minecraft is the user's data folder (worlds, logs, mod jars). Expose
  # it to the VM via a bind mount so the virtiofsd share can read it
  # without loosening /home/xavier's 0700 permissions: accessing
  # /srv/minecraft bypasses /home/xavier traversal entirely.
  fileSystems."/srv/minecraft" = {
    device = "/home/xavier/minecraft";
    fsType = "none";
    options = ["bind"];
  };

  # ---------------------------------------------------------------------
  # Remote access, no VPN for guests: dumbpipe (iroh)
  #
  # Friends connect from anywhere with one command and a "ticket": no
  # public IP, no port forwarding, no VPN on their side. Both ends dial
  # out; iroh hole-punches a direct QUIC connection through NATs and
  # falls back to n0's public relays (still end-to-end encrypted) when
  # punching fails.
  #
  # The ticket is a bearer credential for the exposed port: anyone holding
  # it can connect. Rotate by deleting /var/lib/dumbpipe/secret and
  # restarting dumbpipe-keygen + dumbpipe-minecraft — all previously
  # shared tickets die with the old node ID.

  users.users.dumbpipe = {
    isSystemUser = true;
    group = "dumbpipe";
  };
  users.groups.dumbpipe = {};

  # Stable endpoint identity: a secret key generated once and kept outside
  # the Nix store. Without a persistent key the node ID (and thus every
  # shared ticket) changes on each restart.
  systemd.services.dumbpipe-keygen = {
    description = "Generate persistent dumbpipe endpoint secret";
    serviceConfig = {
      Type = "oneshot";
      User = "dumbpipe";
      Group = "dumbpipe";
      StateDirectory = "dumbpipe";
      StateDirectoryMode = "0700";
      UMask = "0077";
    };
    script = ''
      secret=/var/lib/dumbpipe/secret
      if [ ! -f "$secret" ]; then
        printf 'IROH_SECRET=%s\n' "$(${pkgs.openssl}/bin/openssl rand -hex 32)" > "$secret"
      fi
    '';
  };

  # Expose the minecraft VM's forwarded host port (see forwardPorts in
  # ./minecraft/default.nix; keep the two 25565s in sync) over iroh.
  # Runs on the host rather than inside the guest so the iroh endpoint is
  # not nested behind the VM's user-mode NAT, which would push more
  # traffic onto relay fallback.
  systemd.services.dumbpipe-minecraft = {
    description = "Expose minecraft VM (host port 25565) over iroh via dumbpipe";
    wantedBy = ["multi-user.target"];
    after = ["dumbpipe-keygen.service" "microvm@minecraft.service"];
    wants = ["microvm@minecraft.service"];
    requires = ["dumbpipe-keygen.service"];
    serviceConfig = {
      User = "dumbpipe";
      Group = "dumbpipe";
      StateDirectory = "dumbpipe";
      EnvironmentFile = "/var/lib/dumbpipe/secret";
      ExecStart = "${pkgs.dumbpipe}/bin/dumbpipe listen-tcp --host 127.0.0.1:25565";
      Restart = "on-failure";
      RestartSec = "5";
      # Outbound-only networking: no capabilities or writable paths needed.
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      # AF_NETLINK: iroh's network monitor watches interface changes to
      # re-establish direct connections; blocking netlink makes it die
      # with "Failed to create netmon monitor".
      RestrictAddressFamilies = ["AF_INET" "AF_INET6" "AF_NETLINK" "AF_UNIX"];
      CapabilityBoundingSet = "";
      LockPersonality = true;
    };
  };

  # Current ticket + ready-to-send friend command: `sudo dumbpipe-ticket`.
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "dumbpipe-ticket" ''
      set -euo pipefail
      secret_file=/var/lib/dumbpipe/secret
      if [ "$(id -u)" -ne 0 ]; then
        echo "Run with sudo: $secret_file is readable only by root/dumbpipe." >&2
        exit 1
      fi
      IROH_SECRET=$(sed -n 's/^IROH_SECRET=//p' "$secret_file")
      ticket=$(${pkgs.dumbpipe}/bin/dumbpipe generate-ticket)
      echo "Ticket (valid until the secret is rotated):"
      echo "  $ticket"
      echo
      echo "Friend connects with:"
      echo "  nix run nixpkgs#dumbpipe -- connect-tcp $ticket --addr 127.0.0.1:25565"
    '')
  ];
}
