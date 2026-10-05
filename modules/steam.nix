# Steam — via the NixOS module, which handles the FHS environment and
# setuid integration properly (a bare `pkgs.steam` package does not).
# Personal machines only. NixOS-level: never import this into darwin.
{
  flake.modules.nixos.steam = {pkgs, ...}: {
    programs.steam.enable = true;

    # Gaming performance kit:
    # - gamemode: bumps CPU governor/EPP + renices while a game runs
    #   (launch option: `gamemoderun %command%`)
    # - gamescope: Valve micro-compositor; fixes XWayland frame pacing and
    #   gives games a direct-scanout VRR path (optional, per-game launch
    #   options)
    # - mangohud: overlay to measure what is actually slow. Injected into
    #   the Steam FHS environment so `mangohud %command%` resolves.
    programs.gamemode.enable = true;
    programs.gamescope.enable = true;
    programs.steam.package = pkgs.steam.override {
      extraPkgs = p: [p.mangohud];
    };
  };
}
