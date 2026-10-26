# Deadlock Mod Manager (Tauri GUI). Picks mods at runtime; only the app
# itself is declaratively pinned. Package comes from its own flake, built
# against nixos-unstable — independent of our nixpkgs pin.
#
# Launching on NixOS (upstream issue #719): the manager hardcodes
# `<steam dir>/steam.sh`, the raw upstream bootstrap. Outside NixOS's bwrap
# sandbox that script warns about missing 32-bit libs and cannot cold-start
# Steam. Its built-in fallback when no steam.sh exists is xdg-open, which
# resolves steam:// URIs to the properly wrapped Steam on PATH. So the
# manager's custom Steam path setting (in the app's settings UI) points at
# a shim directory mirroring the real Steam dir minus steam.sh.
#
# Do NOT symlink steam.sh itself to the wrapper instead: the home dir is
# bind-mounted INTO Steam's sandbox, so the bootstrap re-enters the wrapper
# from inside and loops bwrap until the kernel's namespace nesting limit.
{
  inputs,
  config,
  ...
}: {
  home.packages = [inputs.deadlock-mod-manager.packages.x86_64-linux.default];

  home.file = let
    steam = "${config.home.homeDirectory}/.local/share/Steam";
    link = config.lib.file.mkOutOfStoreSymlink;
  in {
    # libraryfolders.vdf: lets the manager resolve Deadlock and mod paths in
    # the real libraries. config/userdata: keep account and crosshair
    # features reading the real data. No steam.sh in the shim on purpose.
    ".local/share/steam-nixos-shim/steamapps/libraryfolders.vdf".source = link "${steam}/steamapps/libraryfolders.vdf";
    ".local/share/steam-nixos-shim/config".source = link "${steam}/config";
    ".local/share/steam-nixos-shim/userdata".source = link "${steam}/userdata";
  };
}
