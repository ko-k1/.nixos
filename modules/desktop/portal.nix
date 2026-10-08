# Shared xdg-desktop-portal base. Compositor modules (hyprland/niri) only
# ADD their backend to `extraPortals` / `config`; this file owns `enable`
# so the two backends never fight over the same option.
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
