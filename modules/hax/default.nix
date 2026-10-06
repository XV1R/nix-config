# hax: minimalist terminal coding agent (hax -p "…"). Not in nixpkgs yet,
# so the system pkgs gain it through an overlay built from the locked input.
{inputs, ...}: let
  overlay.nixpkgs.overlays = [
    (final: _: {hax = final.callPackage ./_package.nix {src = inputs.hax;};})
  ];
in {
  flake.modules.nixos.hax = overlay;
  flake.modules.darwin.hax = overlay;

  flake.modules.homeManager.hax = {pkgs, ...}: {
    home.packages = [pkgs.hax];
  };
}
