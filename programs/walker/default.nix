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
      # Empty config on purpose: the module's default config comes from
      # walker master, whose enum values (AfterAction SimpleDelete, …) are
      # newer than the nixpkgs walker binary and crash it at startup. An
      # empty config makes walker use its own built-in, version-matched
      # defaults. Revisit when nixpkgs walker catches up.
      config = {};
    };

    # ask: popup query → hax one-shot → answer window (nothing to clipboard)
    home.packages = [pkgs.zenity];
    home.file.".local/bin/ask" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        # Store paths, not bare names: the keybinding runs outside a login shell.
        q=$(${pkgs.zenity}/bin/zenity --entry --title "ask" --text "Ask hax:" 2>/dev/null) || exit 0
        [ -n "$q" ] || exit 0
        ${pkgs.hax}/bin/hax -p "$q" | ${pkgs.zenity}/bin/zenity --text-info --title "hax" --width 640 --height 480
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
        command = "${config.home.profileDirectory}/bin/walker";
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
