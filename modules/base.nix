# Home Manager base shared by every host's user: the common feature set
# and everyday CLI tools. Host-specific features are added by each host.
{config, ...}: let
  inherit (config.flake.modules) homeManager;
in {
  flake.modules.homeManager.base = {pkgs, ...}: {
    imports = [
      homeManager.identity
      homeManager.nix-skills
      homeManager.nix-index
      homeManager.opencode
      homeManager.helix
      homeManager.git
      homeManager.delta
      homeManager.gh
      homeManager.jujutsu
      homeManager.nh
      homeManager.shell
    ];
    # username/homeDirectory are per-host: set in each host's user.
    home.stateVersion = "26.05";

    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      fd
      dust
      jq
      btop
      tokei
      alejandra
      statix # nix linter; alejandra formats, statix finds antipatterns
    ];
  };
}
