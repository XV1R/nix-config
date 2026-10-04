{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf pkgs.stdenv.isLinux {
    # Spotlight-style launcher. Modules come from the walker/elephant flakes
    # (wired in flake.nix); the walker package is the cached nixpkgs build,
    # elephant uses the flake's elephant-with-providers.
    programs.walker = {
      enable = true;
      package = pkgs.walker;
      runAsService = true;
    };

    # ask: popup query → hax one-shot → answer window (nothing to clipboard)
    home.packages = [pkgs.zenity];
    home.file.".local/bin/ask" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        q=$(zenity --entry --title "ask" --text "Ask hax:" 2>/dev/null) || exit 0
        [ -n "$q" ] || exit 0
        hax -p "$q" | zenity --text-info --title "hax" --width 640 --height 480
      '';
    };

    dconf.settings = {
      # Bind walker to Super+Space; free it from GNOME's input-source switch
      "org/gnome/desktop/wm/keybindings" = {
        switch-input-source = [];
        switch-input-source-backward = [];
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "walker";
        command = "walker";
        binding = "<Super>space";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "ask hax";
        command = "${config.home.homeDirectory}/.local/bin/ask";
        binding = "<Super>x";
      };
    };
  };
}
