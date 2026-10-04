{
  programs.gh = {
    enable = true;
    # Let `jj git push` / git authenticate to GitHub over HTTPS via gh.
    gitCredentialHelper.enable = true;
  };
}
