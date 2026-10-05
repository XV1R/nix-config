{
  flake.modules.homeManager.jujutsu = {
    config,
    pkgs,
    ...
  }: {
    # diffnav pages `jj diff`/`jj show`; jjui is the terminal UI
    home.packages = [pkgs.diffnav pkgs.jjui];

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
            "--when".commands = ["diff" "show"];
            ui.pager = "diffnav";
          }
          {
            "--when".environments = ["JJUI"];
            ui.diff-formatter = "delta";
          }
        ];
      };
    };
  };
}
