{ config, pkgs, lib, ... }:

{
    xdg.configFile."alacritty/alacritty.yml" = {
        text = lib.generators.toYAML {} {
            font = {
                normal.family = "Miracode";
                size = 16;
            };


            shell = {
                program = "${pkgs.bash}/bin/bash";
            };
        };

    };

    home.sessionVariables = {
        TERMINAL = "alacritty";
    };
}
