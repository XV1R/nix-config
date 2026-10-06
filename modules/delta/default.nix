{
  flake.modules.homeManager.delta = {
    config,
    lib,
    ...
  }: {
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
  };
}
