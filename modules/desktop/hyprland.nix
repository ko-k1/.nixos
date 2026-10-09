# Hyprland (system side). User-side config lives in home/koki/hyprland.nix
# so system and home concerns never mix. Toggle with
# `myDesktop.hyprland.enable`.
#
# Compositor + portal + UWSM come from nixpkgs-unstable (stable lags and
# breaks hyprglass). `unstable` arrives via flake specialArgs.
{
  config,
  lib,
  pkgs,
  unstable,
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
    # withUWSM enables programs.uwsm (user units, uwsm binary,
    # dbus-broker). Without it, the hyprland-uwsm.desktop session fails
    # with `systemctl --user start wayland-session-bindpid@... exit
    # status 5` (missing wayland-session-bindpid@.service).
    programs.hyprland = {
      enable = true;
      package = unstable.hyprland;
      portalPackage = unstable.xdg-desktop-portal-hyprland;
      withUWSM = true;
    };
    # Explicit (withUWSM already sets this). Pinned to unstable so the
    # user units match the uwsm binary baked into unstable hyprland's
    # hyprland-uwsm.desktop.
    programs.uwsm = {
      enable = true;
      package = unstable.uwsm;
    };

    # NOTE: no xdg.portal.extraPortals here — programs.hyprland already
    # ships portalPackage's user units; adding stable's portal too
    # collides on xdg-desktop-portal-hyprland.service.
    xdg.portal.config.hyprland.default = [
      "hyprland"
      "gtk"
    ];
  };
}
