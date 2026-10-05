# Prism Launcher — Minecraft client launcher (official MS login, mod
# loaders). Cross-platform: safe to append on any host.
{
  flake.modules.homeManager.prismlauncher = {pkgs, ...}: {
    home.packages = [pkgs.prismlauncher];
  };
}
