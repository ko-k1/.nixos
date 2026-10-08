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
  };
}
