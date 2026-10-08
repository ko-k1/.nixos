# Hyprland (system side). User-side config lives in home/koki/hyprland.nix
# so system and home concerns never mix. Toggle with
# `myDesktop.hyprland.enable`.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myDesktop.hyprland;
in
{
  options.myDesktop.hyprland.enable = lib.mkEnableOption "Hyprland compositor" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;

    xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
    xdg.portal.config.hyprland.default = [
      "hyprland"
      "gtk"
    ];
  };
}
