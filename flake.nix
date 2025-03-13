{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
	home-manager = {
    		url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
	nvf.url = "github:notashelf/nvf";

  };

  outputs = { home-manager ,nixpkgs, nvf, ... }: 
	let 
		system = "x86_64-linux";
		pkgs = nixpkgs.legacyPackages.${system};
	in {
			homeConfigurations."xavier" = home-manager.lib.homeManagerConfiguration {
					inherit pkgs;
					modules = [ 
						./home.nix 
						nvf.homeManagerModules.default
					]; 
				};
  	};
}
