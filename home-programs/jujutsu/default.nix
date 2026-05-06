{ config, ... }:
let
  gitUser = config.programs.git.settings.user;
in {
  programs.jujutsu = {
    enable = true;
    settings = {
      aliases = {
        g = [ "git" ];
      };
      ui = {
        editor = "hx";
      };
      user = {
        name = gitUser.name;
        email = gitUser.email;
      };
    };
  };
}
