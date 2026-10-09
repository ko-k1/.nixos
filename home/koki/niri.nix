# Niri user config (KDL). Compositor enablement is system-side
# (modules/desktop/niri.nix). The config is managed verbatim (was
# hand-maintained in ~/.config/niri/config.kdl) — a stub here would make
# Home Manager back up the real 675-line config on first switch.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.configFile."niri/config.kdl".source = ./dotfiles/niri/config.kdl;
}
