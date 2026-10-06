# Licensed Berkeley Mono copy, installed as a system font (zip is gitignored).
{
  flake.modules.nixos.berkeley-mono = {pkgs, ...}: {
    fonts.packages = [(pkgs.callPackage ./_package.nix {})];
  };
}
