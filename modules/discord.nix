# Discord — voice/chat client. Personal machines only: append this feature
# to a host's module list to install it.
{
  flake.modules.homeManager.discord = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = lib.optionals pkgs.stdenv.isLinux [pkgs.discord];
  };
}
