{inputs, ...}: {
  flake.modules.homeManager.nix-index = {
    imports = [inputs.nix-index-database.homeModules.nix-index];

    # comma: ephemeral package runs (`, cowsay`); the imported module also
    # enables programs.nix-index with the prebuilt database, powering
    # nix-locate and the command-not-found shell hook.
    programs.nix-index-database.comma.enable = true;
  };
}
