{
  config,
  lib,
  ...
}: {
  # The git integration only pages diff/log/show/blame; core.pager covers
  # every other command too.
  programs.git.settings.core.pager = lib.getExe config.programs.delta.package;

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
    options = {
      navigate = true;
      dark = true;
      line-numbers = true;
      hyperlinks = true;
    };
  };
}
