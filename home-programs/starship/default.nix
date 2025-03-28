{ lib, ... }:
{
    programs.starship = {
        enable = true;
        enableBashIntegration = true;
	    enableFishIntegration = true;
        settings.command_timeout = 99999;
    };
}
