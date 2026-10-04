{
  # Ephemeral package runs (`, cowsay`) and nix-locate, backed by the
  # prebuilt nix-index database (wired in flake.nix sharedModules). The
  # imported module also enables programs.nix-index, whose bash hook
  # replaces the channel-based command-not-found (broken under flakes).
  programs.nix-index-database.comma.enable = true;
}
