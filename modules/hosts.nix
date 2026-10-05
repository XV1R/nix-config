# Host definitions. Features in modules/ are appended per host: a module
# imported here exists on that machine, one not imported doesn't. Base Home
# Manager config (home.nix + shared modules) applies to every host.
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) darwin homeManager;

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
      darwin.nix
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
  flake.darwinConfigurations.${macHost} = mac;

  # Short alias for explicitly targeting the Mac configuration.
  flake.darwinConfigurations.mac = mac;
}
