# ShojiWM (flakes input `shojiwm`, wired in lib/helpers.nix).
# Toggle with `myDesktop.shojiwm.enable`.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myDesktop.shojiwm;
in
{
  options.myDesktop.shojiwm.enable = lib.mkEnableOption "ShojiWM compositor" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    programs.shojiwm = {
      enable = true;
      initConfig = {
        enable = true;
        users = [ "koki" ];
      };
    };
  };
}
