# Discord — voice/chat client. Personal machines only: append this feature
# to a host's module list to install it.
{
  pkgs,
  lib,
  ...
}: {
  home.packages = lib.optionals pkgs.stdenv.isLinux [pkgs.discord];
}
