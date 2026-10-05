# MangoHud overlay config, applied when a game is launched with
# `mangohud %command%` (see Steam launch options). Beyond the usual
# fps/frametime/gpu readouts, `vrr` makes the overlay display whether
# Variable Refresh Rate is actually active in-game — the only reliable
# in-session check for the GNOME VRR toggle.
{...}: {
  programs.mangohud = {
    enable = true;
    settings = {
      fps = true;
      frame_timing = true;
      gpu_stats = true;
      vrr = true;
    };
  };
}
