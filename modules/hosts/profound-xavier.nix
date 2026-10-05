# Profound-xavier: the work MacBook (nix-darwin, aarch64). Composed from
# feature modules; only machine facts live here.
{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) darwin homeManager;
  user = "xavier-profound";

  system = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      darwin.home-manager
      darwin.hax
      darwin.nix
      darwin.shell
      darwin.homebrew
      ({pkgs, ...}: {
        nixpkgs.hostPlatform = "aarch64-darwin";

        # Fresh nix-darwin install on this release — do not change after bootstrapping.
        system.stateVersion = 6;

        users.users.${user}.home = "/Users/${user}";

        # Declarative devenv CLI — replaces the imperative `nix profile install`.
        # Project-level devenv.nix files in work repos are untouched by this.
        environment.systemPackages = [pkgs.devenv];

        home-manager.users.${user} = {lib, ...}: {
          imports = [homeManager.base homeManager.hax homeManager.starship];
          home.username = user;
          home.homeDirectory = "/Users/${user}";

          # Tools installed outside Nix on this machine
          home.sessionPath = [
            "/opt/homebrew/opt/libpq/bin" # keg-only psql
            "$HOME/.bun/bin"
            "$HOME/.cargo/bin"
            "$HOME/.codeium/windsurf/bin"
          ];
          home.sessionVariablesExtra = ''
            export PATH="$PATH:$HOME/.docker/bin"
          '';
          home.sessionVariables.BUN_INSTALL = "$HOME/.bun";
          home.shellAliases.vim = "nvim";
          programs.helix.settings.theme = "qt_creator_dark";

          programs.zsh.initContent = lib.mkMerge [
            # Before compinit (order 570) so Docker's completions are found
            (lib.mkOrder 550 "fpath=($HOME/.docker/completions $fpath)")
            ''
              [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
              [[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null
              source "$HOME/infra-tooling/aws/sso/aws-login.sh"
            ''
          ];

          # OrbStack: command-line tools and integration
          programs.zsh.profileExtra = ''
            source ~/.orbstack/shell/init.zsh 2>/dev/null || :
          '';
        };
      })
    ];
  };
in {
  # Named after the Mac's LocalHostName, the darwin-rebuild default
  flake.darwinConfigurations.Profound-xavier = system;

  # Short alias for explicitly targeting the Mac configuration.
  flake.darwinConfigurations.mac = system;
}
