{
  flake.modules.homeManager.git = {config, ...}: {
    programs.git = {
      enable = true;
      settings.user = {
        inherit (config.var.git) name email;
      };
    };
  };
}
