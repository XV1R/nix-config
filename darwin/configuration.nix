# nix-darwin configuration for the work MacBook (aarch64).
# The host/user placeholders live in flake.nix (macHost / macUser); this
# module receives macUser via specialArgs so there is one source of truth.
{
  config,
  pkgs,
  inputs,
  macUser,
  ...
}: {
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Bare `nixpkgs#` references (incl. comma) resolve to the exact locked
  # rev this system was built from (the darwin branch).
  nix.registry.nixpkgs.flake = inputs.nixpkgs-darwin;

  # Fresh nix-darwin install on this release — do not change after bootstrapping.
  system.stateVersion = 6;

  # nix-darwin owns the Nix installation regardless of which installer
  # bootstrapped the machine; keep flakes enabled either way.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Carried over from the Nix installer's /etc/nix/nix.conf and nix.custom.conf,
  # which nix-darwin replaces.
  nix.settings = {
    # Installer defaults
    always-allow-substitutes = true;
    bash-prompt-prefix = "(nix:$name)\\040";

    # Added to nix-darwin's default [root]. Lets devenv and project flakes add
    # their own caches; equivalent to root access through the daemon.
    trusted-users = [macUser];

    # devenv and its cachix dependency (see environment.systemPackages)
    extra-substituters = ["https://devenv.cachix.org" "https://cachix.cachix.org"];

    extra-trusted-public-keys = [
      # devenv, cachix
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      # Profound's binary cache
      "profound-nix-binary-cache-1:f1ZchuV4BJnwqQIn0RJlIRkzTFgUrFZNRkBW6sZfDqk="
    ];
  };

  # Was enabled by hand in /etc/pam.d/sudo_local, which nix-darwin now writes
  security.pam.services.sudo_local.touchIdAuth = true;

  # Home Manager (wired in flake.nix) needs the user's home path.
  users.users.${macUser}.home = "/Users/${macUser}";

  # Existing dotfiles (~/.profile, helix, jj, gh configs) are renamed to
  # *.before-home-manager instead of aborting activation.
  home-manager.backupFileExtension = "before-home-manager";

  # Declarative devenv CLI — replaces the imperative `nix profile install`.
  # Project-level devenv.nix files in work repos are untouched by this.
  # nh covers `nh darwin switch` / `nh clean` on this side too.
  environment.variables.NH_FLAKE = "/Users/${macUser}/nix-config";
  environment.systemPackages = [
    # Stable nixpkgs lags devenv's releases
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.devenv
    pkgs.nh
  ];
}
