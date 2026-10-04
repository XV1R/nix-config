{config, ...}: {
  programs.git = {
    enable = true;
    settings.user = {
      inherit (config.var.git) name email;
    };
  };
}
