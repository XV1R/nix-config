{
  lib,
  pkgs,
  ...
}: {
  # TR-100 Machine Report (https://github.com/usgraphics/usgc-machine-report)
  # Vendored per its philosophy: edit the source directly.
  # Linux-only: reads /proc, uses Linux `last` and coreutils `uptime`.
  config = lib.mkIf pkgs.stdenv.isLinux {
    home.file.".machine_report.sh" = {
      source = ./machine_report.sh;
      executable = true;
    };

    # Show in every new interactive shell
    programs.bash.initExtra = lib.mkAfter ''
      if [[ $- == *i* ]]; then
        "$HOME/.machine_report.sh"
      fi
    '';
  };
}
