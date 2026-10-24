# Deadlock Mod Manager (Tauri GUI). Picks mods at runtime; only the app
# itself is declaratively pinned. Package comes from its own flake, built
# against nixos-unstable — independent of our nixpkgs pin.
#
# Launching: the manager hardcodes `<steam dir>/steam.sh` (upstream issue
# #719). On NixOS that bare script warns about missing 32-bit libs because
# the real Steam is the bwrap FHS wrapper on PATH. We tried symlinking
# steam.sh to the wrapper, but the home dir is bind-mounted INTO Steam's
# sandbox, so the bootstrap re-entered the wrapper from inside and looped
# bwrap until the kernel's namespace depth limit. Do not symlink it again:
# either start Steam first (then the manager just hands the running client
# the steam:// URI) or click OK on the warning dialog.
{inputs, ...}: {
  home.packages = [inputs.deadlock-mod-manager.packages.x86_64-linux.default];
}
