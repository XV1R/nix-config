{config, ...}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        inherit (config.var.git) name email;
      };
      aliases.g = ["git"];
      ui.editor = "hx";
    };
  };
}
