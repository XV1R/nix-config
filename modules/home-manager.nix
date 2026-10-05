# Home Manager as part of the system configuration, on NixOS and nix-darwin.
# Users are declared by each host; their modules use the system's pkgs.
{inputs, ...}: let
  settings.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
  };
in {
  flake.modules.nixos.home-manager.imports = [
    inputs.home-manager.nixosModules.home-manager
    settings
  ];

  flake.modules.darwin.home-manager.imports = [
    inputs.home-manager.darwinModules.home-manager
    settings
  ];
}
