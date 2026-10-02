{
  description = "NixOS flake for saturn";

  inputs = {
    # NixOS official package source, using the nixos-26.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-skills.url = "github:olafkfreund/nix-skills";
  };

  outputs = { self, nixpkgs, home-manager, nix-skills, ... }@inputs: {
    nixosConfigurations.saturn = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [ nix-skills.homeManagerModules.default ];
          home-manager.users.xavier = import ./home.nix;
        }
      ];
    };
  };
}
