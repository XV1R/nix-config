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

    # Prebuilt nix-index database: powers comma and command-not-found
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Oneshot agent (hax -p "…"): source pin for our package in packages/.
    # The repo has no flake.nix — it is a plain source pin.
    hax = {
      url = "github:OleksandrChekhovskyi/hax";
      flake = false;
    };

    # Launcher: walker (frontend) + elephant (provider daemon). Imported for
    # their Home Manager modules; walker's package comes from nixpkgs, while
    # elephant uses the flake's elephant-with-providers (nixpkgs ships the
    # daemon without providers).
    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };

    # MicroVMs (see microvms/) and the Minecraft server stack for the guest
    microvm.url = "github:microvm-nix/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nix-minecraft.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";

    # Loads every .nix file under modules/ as a flake-parts module
    import-tree.url = "github:vic/import-tree";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
}
