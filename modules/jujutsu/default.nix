{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        inherit (config.var.git) name email;
      };
      aliases = {
        g = ["git"];
        tug = ["bookmark" "advance" "--to" "@-"];
        plan = ["new" "--no-edit" "heads(@::)" "-m"];
        sync = ["git" "fetch" "--all-remotes"];
        restack = ["rebase" "--onto" "trunk()" "--source" "roots(trunk()..) & mutable()"];
        l = ["log" "-r"];
        open = ["log" "-r" "heads(mine()) ~ ::trunk()"];
      };
      ui = {
        editor = "hx";
        default-command = "log";
      };
      "--scope" = [
        {
          # Navigable pager for `jj diff` and `jj show`
          "--when".commands = ["diff" "show"];
          ui.pager = lib.getExe pkgs.diffnav;
        }
        {
          # Inside jjui (which sets JJUI), format diffs with delta
          "--when".environments = ["JJUI"];
          ui.diff-formatter = "delta";
        }
      ];
    };
  };
}
