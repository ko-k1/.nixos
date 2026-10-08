# waybar: applies the Lua-dispatcher fix for Hyprland >= 0.54 (upstream PR
# #5013). Without it, clicking workspace buttons on Hyprland Lua builds
# silently does nothing.
final: prev: {
  waybar = prev.waybar.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ../patches/waybar-lua-dispatch.patch ];
  });
}
