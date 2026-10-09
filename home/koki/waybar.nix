# Waybar. programs.waybar installs the patched waybar (overlays/waybar.nix);
# its settings/style stay unset so HM doesn't generate a config. The real
# config + Mpris/Cava helper scripts are managed verbatim from
# home/koki/dotfiles/waybar (was hand-maintained in ~/.config/waybar/).
{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.waybar.enable = true;
  programs.foot.enable = true;

  xdg.configFile."waybar" = {
    source = ./dotfiles/waybar;
    recursive = true;
  };
}
