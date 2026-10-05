# Host definitions. Features in modules/ are appended per host: a module
# imported here exists on that machine, one not imported doesn't. Base Home
# Manager config (home.nix + shared modules) applies to every host.
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) darwin homeManager nixos;

  # Work laptop's LocalHostName and account name.
  macHost = "Profound-xavier";
  macUser = "xavier-profound";

  mac = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = {inherit macUser inputs;};
    modules = [
      ../darwin/configuration.nix
      darwin.home-manager
      darwin.hax
      {
        home-manager.users.${macUser} = {
          imports = [homeManager.base homeManager.hax];
          home.username = macUser;
          home.homeDirectory = "/Users/${macUser}";
        };
      }
    ];
  };
in {
  flake.nixosConfigurations.saturn = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    # Modules may declare {inputs, ...} to reach flake inputs
    specialArgs = {inherit inputs;};
    modules = [
      ../configuration.nix
      # Appended features (system-level):
      nixos.steam
      nixos.berkeley-mono
      inputs.microvm.nixosModules.host
      ../microvms/host.nix
      nixos.home-manager
      nixos.hax
      {
        # Host appends: system-level features go in modules; user-level
        # features (walker, gnome, machine-report, discord, …) go in the
        # user's Home Manager imports.
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
        # Bare `nixpkgs#` references (incl. comma) resolve to the exact
        # locked rev this system was built from.
        nix.registry.nixpkgs.flake = inputs.nixpkgs;
      }
    ];
  };

  flake.darwinConfigurations.${macHost} = mac;

  # Short alias for explicitly targeting the Mac configuration.
  flake.darwinConfigurations.mac = mac;
}
