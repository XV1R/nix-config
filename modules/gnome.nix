{pkgs, ...}: {
  # GNOME desktop experience — appended only to hosts that run GNOME, so
  # no platform guards are needed here.

  # System font: Berkeley Mono for the GNOME interface and monospace.
  dconf.settings."org/gnome/desktop/interface" = {
    font-name = "Berkeley Mono 11";
    monospace-font-name = "Berkeley Mono 11";
  };

  # v4l2-ctl: scriptable camera controls (video4linux)
  home.packages = [pkgs.v4l-utils];
}
