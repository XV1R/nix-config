{ config, pkgs, ... }:

let
  # This creates a TOML format generator using the pkgs library
  tomlFormat = pkgs.formats.toml { };
in
{
  # We use .source instead of .text when using pkgs.formats
  xdg.configFile."alacritty/alacritty.toml".source = tomlFormat.generate "alacritty-config" {
    
    font = {
      normal.family = "Miracode";
      size = 20;
    };

    shell = {
      program = "${pkgs.bash}/bin/bash";
    };

    # FIXED: 'colors' is now properly nested inside the settings object
    colors = {
      primary = {
        background = "${config.var.uchu.yin.light}";
        foreground = "${config.var.uchu.general.yin}";
      };
      cursor = {
        text = "${config.var.uchu.orange.base}";
        cursor = "${config.var.uchu.orange.light}";
      };
      normal = {
        black = "${config.var.uchu.general.yin}";
        red = "${config.var.uchu.red.dark}";
        green = "${config.var.uchu.green.dark}";
        yellow = "${config.var.uchu.yellow.dark}";
        blue = "${config.var.uchu.blue.dark}";
        magenta = "${config.var.uchu.purple.dark}";
        cyan = "${config.var.uchu.blue.base}";
        white = "${config.var.uchu.general.yin}";
      };
      bright = {
        black = "${config.var.uchu.general.yin}";
        red = "${config.var.uchu.red.base}";
        green = "${config.var.uchu.green.base}";
        yellow = "${config.var.uchu.yellow.base}";
        blue = "${config.var.uchu.pink.base}";
        magenta = "${config.var.uchu.purple.base}";
        cyan = "${config.var.uchu.blue.light}";
        white = "${config.var.uchu.yin.light}";
      };
    };
  };

  # Ensure Alacritty knows to look for this
  home.sessionVariables = {
    TERMINAL = "alacritty";
  };
}
