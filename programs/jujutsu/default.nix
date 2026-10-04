{config, ...}:
let gitUser = config.programs.git.settings.user;
in {
  programs.jujutsu = {
    enable = true;
    user.name = gitUser.name;
    user.email = gitUser.email;
    settings = {
      aliases.g = [ "git" ];
      ui.editor = "hx";
    };
  };
}
