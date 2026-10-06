# TR-100 Machine Report (https://github.com/usgraphics/usgc-machine-report)
# Vendored per its philosophy: edit the source directly.
# Appended only to linux hosts (reads /proc, uses Linux `last`).
{
  flake.modules.homeManager.machine-report = {lib, ...}: {
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
