{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 11.0;
        normal.family = "JetBrainsMono Nerd Font";
      };
      window.opacity = 0.95;
      colors = {
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
      };
    };
  };
}
