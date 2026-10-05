{pkgs, ...}: {
  # GNOME desktop experience — appended only to hosts that run GNOME, so
  # no platform guards are needed here.

  # System font: Berkeley Mono for the GNOME interface and monospace.
  dconf.settings."org/gnome/desktop/interface" = {
    font-name = "Berkeley Mono 11";
    monospace-font-name = "Berkeley Mono 11";
  };

  # VRR (FreeSync): the panel is 5120x2160@180Hz VRR-capable, but mutter
  # gates VRR behind an experimental feature — without it, vsynced games
  # quantize to 180/90/60 fps instead of every refresh in between.
  # After a re-login this exposes the VRR toggle in Settings → Displays.
  dconf.settings."org/gnome/mutter".experimental-features = [
    "variable-refresh-rate"
  ];

  # v4l2-ctl: scriptable camera controls (video4linux)
  home.packages = [pkgs.v4l-utils];
}
