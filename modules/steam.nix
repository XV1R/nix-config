# Steam — via the NixOS module, which handles the FHS environment and
# setuid integration properly (a bare `pkgs.steam` package does not).
# Personal machines only. NixOS-level: never import this into darwin.
{
  programs.steam.enable = true;
}
