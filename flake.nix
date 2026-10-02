{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-26.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.saturn = nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };
  };
}
