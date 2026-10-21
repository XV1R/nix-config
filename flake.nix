{
  description = "Nix flake for saturn (NixOS) and the work Mac (nix-darwin)";

  inputs = {
    # NixOS official package source, using the nixos-26.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Darwin branch of the same release: better aarch64-darwin cache coverage
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    # For fast-moving tools whose 26.05 versions fall behind (see
    # modules/dev-tools.nix). nixpkgs-unstable, unlike nixos-unstable, is
    # gated on darwin builds too.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pinned to the release matching nixpkgs 26.05
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # Installs and pins Homebrew itself on the Mac; what Homebrew installs
    # is declared with nix-darwin's homebrew.* options
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

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

    # Rust and C/C++ build cache (not in nixpkgs). Keeps its own nixpkgs and
    # Rust toolchain pins; it has no binary cache, so updates build locally.
    kache.url = "github:kunobi-ninja/kache/stable";

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

    # Deadlock mod manager (GUI app only — mod selection is runtime state)
    deadlock-mod-manager.url = "github:deadlock-mod-manager/deadlock-mod-manager";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} (
      {config, ...}: {
        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];

        imports = [./hosts.nix];

        perSystem = {pkgs, ...}: {
          # `nix fmt` runs alejandra over the tree. Bare `nix fmt` passes no
          # arguments, which would make alejandra read stdin, so default to `.`.
          formatter = pkgs.writeShellScriptBin "alejandra" ''
            if [[ "$#" -eq 0 ]]; then
              set -- .
            fi
            exec ${pkgs.alejandra}/bin/alejandra "$@"
          '';

          packages.default =
            if pkgs.stdenv.isLinux
            then config.flake.nixosConfigurations.saturn.config.system.build.toplevel
            else config.flake.darwinConfigurations.mac.system;
        };
      }
    );
}
