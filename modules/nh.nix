# nh: rebuilds with a derivation diff and confirmation prompt. Every user
# keeps this repository checked out at ~/config.
{
  flake.modules.homeManager.nh = {config, ...}: {
    programs.nh = {
      enable = true;
      flake = "${config.home.homeDirectory}/config";
    };
  };

  # Weekly garbage collection with retention, run system-wide.
  flake.modules.nixos.nh = {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep-since 4d --keep 5";
      };
    };
  };
}
