{ pkgs, lib, ... }:

{
  programs.zellij = {
    enable = true;
    enableBashIntegration = false;

    settings.theme = "gruvbox-dark"; 
  };
}
