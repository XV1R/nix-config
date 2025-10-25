{pkgs, lib, ... }:
{
    programs.zellij = {
        enable = true;
        enableBashIntegration = true;
        attachExistingSession = true;
    };
}
