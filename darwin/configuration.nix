# nix-darwin configuration for the work MacBook (aarch64).
# The host/user placeholders live in flake.nix (macHost / macUser); this
# module receives macUser via specialArgs so there is one source of truth.
{
  config,
  pkgs,
  macUser,
  ...
}: {
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Fresh nix-darwin install on this release — do not change after bootstrapping.
  system.stateVersion = 6;

  # Home Manager (wired in flake.nix) needs the user's home path.
  users.users.${macUser}.home = "/Users/${macUser}";

  # Declarative devenv CLI — replaces the imperative `nix profile install`.
  # Project-level devenv.nix files in work repos are untouched by this.
  # nh covers `nh darwin switch` / `nh clean` on this side too.
  environment.variables.NH_FLAKE = "/Users/${macUser}/config";
  environment.systemPackages = [
    pkgs.devenv
    pkgs.nh
  ];
}
