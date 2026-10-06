{
  flake.modules.homeManager.git = {config, ...}: {
    programs.git = {
      enable = true;
      settings = {
        user = {
          inherit (config.var.git) name email;
        };
        core.editor = "hx";
        merge.conflictStyle = "zdiff3";
      };
    };
  };
}
