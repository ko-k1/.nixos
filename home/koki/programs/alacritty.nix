# Alacritty config, managed verbatim from home/koki/dotfiles/alacritty
# (was hand-maintained in ~/.config/alacritty/; duskfox theme, 0.4
# opacity). programs.alacritty stays OFF: it would generate a competing
# alacritty.toml. The package itself is in packages.nix.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.configFile."alacritty" = {
    source = ../dotfiles/alacritty;
    recursive = true;
  };
}
