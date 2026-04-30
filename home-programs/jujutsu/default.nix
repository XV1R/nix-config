{ config, ... }:
let
  gitUser = config.programs.git.settings.user;
in {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = gitUser.name;
        email = gitUser.email;
      };
    };
  };
}
