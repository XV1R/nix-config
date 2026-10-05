# Nix itself: flakes everywhere, and bare `nixpkgs#` references (incl.
# comma) resolve to the exact locked rev each system was built from.
{inputs, ...}: let
  flakes.nix.settings.experimental-features = ["nix-command" "flakes"];
in {
  flake.modules.nixos.nix = {
    imports = [flakes];
    nix.registry.nixpkgs.flake = inputs.nixpkgs;
  };

  flake.modules.darwin.nix = {
    imports = [flakes];
    # The darwin branch of the same release (see flake.nix)
    nix.registry.nixpkgs.flake = inputs.nixpkgs-darwin;
    # Defaults the Nix installer had written to /etc/nix/nix.conf
    nix.settings = {
      always-allow-substitutes = true;
      bash-prompt-prefix = "(nix:$name)\\040";
    };
  };
}
