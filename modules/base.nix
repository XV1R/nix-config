# Home Manager base shared by every host's user: the common feature set
# and everyday CLI tools. Host-specific features are added by each host.
{config, ...}: let
  inherit (config.flake.modules) homeManager;
in {
  flake.modules.homeManager.base = {pkgs, ...}: {
    imports = [
      homeManager.identity
      ../legacy/nix-skills.nix
      ../legacy/nix-index.nix
      ../legacy/opencode
      homeManager.helix
      homeManager.git
      homeManager.delta
      homeManager.gh
      homeManager.jujutsu
    ];
    # username/homeDirectory are per-host: set in each host's user.
    home.stateVersion = "26.05";

    programs.home-manager.enable = true;

    # Manages ~/.bashrc so home.shellAliases and zoxide's shell hook take effect.
    programs.bash.enable = true;

    # zoxide needs shell integration; this installs it and sets up the `z` hook.
    programs.zoxide.enable = true;

    home.packages = with pkgs; [
      eza
      fd
      dust
      just
      jq
      btop
      procs
      prettyping
      tokei
      glow
      alejandra
      statix # nix linter; alejandra formats, statix finds antipatterns
      zoxide
    ];

    home.shellAliases = {
      ls = "eza --group-directories-first";
      l = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
      ps = "procs";
      pgrep = "procs --pgrep";
      ping = "prettyping --nolegend";
      md = "glow";
      c = "z";
    };
  };
}
