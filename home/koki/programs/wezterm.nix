# WezTerm config, managed verbatim from home/koki/dotfiles/wezterm
# (was hand-maintained in ~/.config/wezterm/). programs.wezterm stays OFF:
# it always writes its own wezterm.lua. The package is in packages.nix.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.configFile."wezterm/wezterm.lua".source = ../dotfiles/wezterm/wezterm.lua;
}
