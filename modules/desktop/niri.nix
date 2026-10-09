# Niri (system side). User-side config lives in home/koki/niri.nix.
# Toggle with `myDesktop.niri.enable`.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myDesktop.niri;
in
{
  options.myDesktop.niri.enable = lib.mkEnableOption "Niri compositor" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;
    # niri spawns xwayland-satellite on demand for X11 clients (Steam,
    # Discord). It used to arrive transitively via the shojiwm module;
    # newer shojiwm no longer ships it, so pin it here explicitly.
    environment.systemPackages = [ pkgs.xwayland-satellite ];
  };
}
