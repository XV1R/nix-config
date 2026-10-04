{
  description = "Nix flake for saturn (NixOS) and the work Mac (nix-darwin)";

  inputs = {
    # NixOS official package source, using the nixos-26.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Darwin branch of the same release: better aarch64-darwin cache coverage
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pinned to the release matching nixpkgs 26.05
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    nix-skills.url = "github:olafkfreund/nix-skills";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-darwin,
    nix-darwin,
    home-manager,
    nix-skills,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    darwinSystem = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
    darwinPkgs = nixpkgs-darwin.legacyPackages.${darwinSystem};

    # TODO(mac): fill in from the laptop:
    #   host: scutil --get LocalHostName
    #   user: whoami
    macHost = "workbook";
    macUser = "work";

    # `nix fmt` runs alejandra over the tree. Bare `nix fmt` passes no
    # arguments, which would make alejandra read stdin, so default to `.`.
    alejandraFmt = p:
      p.writeShellScriptBin "alejandra" ''
        if [[ "$#" -eq 0 ]]; then
          set -- .
        fi
        exec ${p.alejandra}/bin/alejandra "$@"
      '';

    saturn = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [nix-skills.homeManagerModules.default];
          home-manager.users.xavier = {
            imports = [./home.nix];
            home.username = "xavier";
            home.homeDirectory = "/home/xavier";
          };
        }
      ];
    };

    mac = nix-darwin.lib.darwinSystem {
      system = darwinSystem;
      specialArgs = {inherit macUser;};
      modules = [
        ./darwin/configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [nix-skills.homeManagerModules.default];
          home-manager.users.${macUser} = {
            imports = [./home.nix];
            home.username = macUser;
            home.homeDirectory = "/Users/${macUser}";
          };
        }
      ];
    };
  in {
    # Bare `nix build` / `nix eval` operate on the system closure
    packages.${system}.default = saturn.config.system.build.toplevel;
    packages.${darwinSystem}.default = mac.system;

    formatter.${system} = alejandraFmt pkgs;
    formatter.${darwinSystem} = alejandraFmt darwinPkgs;

    nixosConfigurations.saturn = saturn;

    # darwin-rebuild resolves the attr from the Mac's LocalHostName; the
    # `mac` alias lets us build and validate from saturn before the real
    # name is filled in.
    darwinConfigurations.${macHost} = mac;
    darwinConfigurations.mac = mac;
  };
}
