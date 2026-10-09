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
}
