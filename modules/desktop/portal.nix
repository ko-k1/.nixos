# Shared xdg-desktop-portal base. Compositor backends come from their own
# programs.* options (hyprland pins portalPackage from unstable); this
# file only owns `enable` + the gtk fallback so backends never fight over
# the same option.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  # dconf backs the GTK/libadwaita settings written by home/koki/theme.nix
  # (color-scheme, gtk/icon/cursor theme) and read by the gtk portal.
  programs.dconf.enable = true;
}
