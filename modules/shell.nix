# Interactive shells: bash and zsh get the same aliases, PATH and tool
# integrations, whichever one a host's user logs into.
let
  # Home Manager's zsh runs compinit for each user; a global one only adds startup time.
  zsh.programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };
in {
  flake.modules.nixos.shell = zsh;
  flake.modules.darwin.shell = zsh;

  flake.modules.homeManager.shell = {pkgs, ...}: {
    programs.bash.enable = true;
    programs.zsh.enable = true;

    # zoxide's shell hook provides `z` (and the `c` alias below).
    programs.zoxide.enable = true;

    # Ctrl-R history search, Ctrl-T file picker, ** completion
    programs.fzf.enable = true;

    home.sessionPath = ["$HOME/.local/bin"];

    # Tools called by the aliases
    home.packages = with pkgs; [eza procs prettyping glow just];

    home.shellAliases = {
      ".." = "cd ..";
      ls = "eza --group-directories-first";
      l = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
      ps = "procs";
      pgrep = "procs --pgrep";
      ping = "prettyping --nolegend";
      md = "glow";
      c = "z";
      g = "git";
      j = "just";
    };
  };
}
