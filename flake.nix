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

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-skills,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # `nix fmt` runs alejandra over the tree. Bare `nix fmt` passes no
    # arguments, which would make alejandra read stdin, so default to `.`.
    formatter.${system} = pkgs.writeShellScriptBin "alejandra" ''
      if [[ "$#" -eq 0 ]]; then
        set -- .
      fi
      exec ${pkgs.alejandra}/bin/alejandra "$@"
    '';

    nixosConfigurations.saturn = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [nix-skills.homeManagerModules.default];
          home-manager.users.xavier = import ./home.nix;
        }
      ];
    };
  };
}
