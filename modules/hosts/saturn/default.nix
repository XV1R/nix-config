# saturn: personal NixOS desktop. Machine settings live in
# ./_configuration.nix; everything else is composed from feature modules.
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) homeManager nixos;
in {
  flake.nixosConfigurations.saturn = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    # Modules may declare {inputs, ...} to reach flake inputs
    specialArgs = {inherit inputs;};
    modules = [
      ./_configuration.nix
      nixos.steam
      nixos.berkeley-mono
      nixos.minecraft
      nixos.home-manager
      nixos.hax
      nixos.nix
      nixos.nh
      {
        home-manager.users.xavier = {
          imports = [
            homeManager.base
            homeManager.hax
            homeManager.walker
            homeManager.gnome
            homeManager.machine-report
            homeManager.bitwarden
            homeManager.discord
            homeManager.prismlauncher
          ];
          home.username = "xavier";
          home.homeDirectory = "/home/xavier";
        };
      }
    ];
  };
}
