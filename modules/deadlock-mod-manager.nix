# Deadlock Mod Manager (Tauri GUI). Picks mods at runtime; only the app
# itself is declaratively pinned. Package comes from its own flake, built
# against nixos-unstable — independent of our nixpkgs pin.
{inputs, ...}: {
  home.packages = [inputs.deadlock-mod-manager.packages.x86_64-linux.default];
}
