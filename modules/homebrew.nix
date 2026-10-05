# Homebrew stays available for tools Nix doesn't manage. Its directories
# come after the Nix profiles (order 1000) and before the macOS system
# directories (order 1200), so Nix wins for anything installed by both.
{
  flake.modules.darwin.homebrew = {lib, ...}: {
    environment.systemPath = lib.mkOrder 1100 ["/opt/homebrew/bin" "/opt/homebrew/sbin"];
  };
}
