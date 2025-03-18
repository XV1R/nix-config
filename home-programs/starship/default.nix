{ lib, ... }:
{
    programs.starship = {
        enable = true;
        enableBashIntegration = true;

        settings.command_timeout = 99999;
    };
}
