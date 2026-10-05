# Profound-xavier: the work MacBook (nix-darwin, aarch64). Composed from
# feature modules; only machine facts live here.
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) darwin homeManager;
  user = "xavier-profound";

  system = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      darwin.home-manager
      darwin.hax
      darwin.nix
      darwin.shell
      darwin.homebrew
      ({pkgs, ...}: {
        nixpkgs.hostPlatform = "aarch64-darwin";

        # Fresh nix-darwin install on this release — do not change after bootstrapping.
        system.stateVersion = 6;

        users.users.${user}.home = "/Users/${user}";

        # Declarative devenv CLI — replaces the imperative `nix profile install`.
        # Project-level devenv.nix files in work repos are untouched by this.
        environment.systemPackages = [pkgs.devenv];

        home-manager.users.${user} = {
          imports = [homeManager.base homeManager.hax homeManager.starship];
          home.username = user;
          home.homeDirectory = "/Users/${user}";
        };
      })
    ];
  };
in {
  # Named after the Mac's LocalHostName, the darwin-rebuild default
  flake.darwinConfigurations.Profound-xavier = system;

  # Short alias for explicitly targeting the Mac configuration.
  flake.darwinConfigurations.mac = system;
}
