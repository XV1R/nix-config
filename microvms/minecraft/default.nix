# Minecraft server, running in a MicroVM on saturn.
# Data lives in the host's ~/minecraft (bind-mounted to /srv/minecraft,
# then shared into the guest via virtiofs with uid translation so files
# created by the server show up owned by xavier on the host).
# Mods later: add entries to services.minecraft-servers.servers.paper.symlinks
# (see https://github.com/Infinidoge/nix-minecraft README).
{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];

  nixpkgs = {
    overlays = [inputs.nix-minecraft.overlay];
    # Minecraft server jars are unfree
    config.allowUnfree = true;
  };

  networking.hostName = "minecraft";

  microvm = {
    hypervisor = "qemu";
    vcpu = 2;
    mem = 4096;

    # User-mode networking: no host network changes; 25565 is forwarded.
    interfaces = [
      {
        type = "user";
        id = "minecraft";
        mac = "02:00:00:4d:63:01";
      }
    ];
    forwardPorts = [
      {
        proto = "tcp";
        from = "host";
        host.port = 25565;
        guest.port = 25565;
      }
    ];

    shares = [
      # Share the host store so the guest image stays tiny
      {
        tag = "ro-store";
        proto = "virtiofs";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
      {
        tag = "minecraft";
        proto = "virtiofs";
        source = "/srv/minecraft";
        mountPoint = "/srv/minecraft";
        posixAcl = false;
        # Guest uid 1000 (the minecraft server user, set below) maps to host
        # uid 1000 (xavier), so guest-created files are owned by xavier.
        extraArgs = ["--translate-uid" "guest:1000:1000:1"];
      }
    ];
  };

  # Align the server user with the host owner (see share translation above)
  users.users.minecraft.uid = 1000;

  services.minecraft-servers = {
    enable = true;
    # Setting this asserts acceptance of Moang's Minecraft EULA
    eula = true;
    openFirewall = true;

    servers.paper = {
      enable = true;
      autoStart = true;
      # NOTE: not pkgs.minecraftServers.paperServers — nix-minecraft's
      # minecraftServers merge list doesn't include the paper tree.
      # NOTE: not pkgs.minecraftServers.paperServers — nix-minecraft's
      # minecraftServers merge list doesn't include the paper tree.
      # Pinned explicitly: the rolling `paper` attr mis-sorts and resolved
      # to 26.3-rc3 (stale pre-release) even though stable builds exist.
      package = pkgs.paperServers.paper-26_3-build_49;
      jvmOpts = "-Xms2G -Xmx3G";
      serverProperties = {
        server-port = 25565;
        motd = "saturn microvm paper";
        max-players = 8;
        difficulty = "normal";
        online-mode = true;
        view-distance = 8;
        white-list = false;
      };
    };
  };

  system.stateVersion = "26.05";
}
