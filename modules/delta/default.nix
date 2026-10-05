{
  flake.modules.homeManager.delta = {...}: {
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
