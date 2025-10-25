{ config, ... }:
let
  username = config.var.git.username;
  email = config.var.git.email;
in {
  programs.git = {
    enable = true;
    settings = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        color.ui = "1";
        user.name = username;
        user.email = email;
    };
    ignores = [
      ".cache/"
      ".DS_Store"
      ".idea/"
      "*.swp"
      "*.elc"
      "auto-save-list"
      ".direnv/"
      "node_modules"
      "result"
      "result-*"
    ];
  };
}
