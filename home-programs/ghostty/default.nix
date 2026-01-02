{ pkgs, lib, config, ... }:

let
  cfg = config.programs.ghostty;
in
{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # Stable icon name by installing into ~/.local/share/icons
  xdg.dataFile."icons/hicolor/128x128/apps/com.mitchellh.ghostty.png".source =
    "${cfg.package}/share/icons/hicolor/128x128/apps/com.mitchellh.ghostty.png";

  # Desktop entry written directly so we can include StartupWMClass
  xdg.dataFile."applications/com.mitchellh.ghostty.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Version=1.0
    Name=Ghostty
    GenericName=Terminal
    Comment=Terminal emulator
    Exec=${cfg.package}/bin/ghostty
    TryExec=${cfg.package}/bin/ghostty
    Terminal=false
    Categories=System;TerminalEmulator;
    StartupNotify=true
    StartupWMClass=ghostty
    Icon=com.mitchellh.ghostty
    Actions=NewWindow;

    [Desktop Action NewWindow]
    Name=New Window
    Exec=${cfg.package}/bin/ghostty
  '';
}

