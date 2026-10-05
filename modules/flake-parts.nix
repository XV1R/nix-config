# Flake-wide settings: supported systems, formatter and default package.
{config, ...}: {
  systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];

  perSystem = {pkgs, ...}: {
    # `nix fmt` runs alejandra over the tree. Bare `nix fmt` passes no
    # arguments, which would make alejandra read stdin, so default to `.`.
    formatter = pkgs.writeShellScriptBin "alejandra" ''
      if [[ "$#" -eq 0 ]]; then
        set -- .
      fi
      exec ${pkgs.alejandra}/bin/alejandra "$@"
    '';

    packages.default =
      if pkgs.stdenv.isLinux
      then config.flake.nixosConfigurations.saturn.config.system.build.toplevel
      else config.flake.darwinConfigurations.mac.system;
  };
}
