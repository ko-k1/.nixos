{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require("wezterm")

      return {
        font = wezterm.font("JetBrainsMono Nerd Font"),
        font_size = 11.0,
        color_scheme = "Catppuccin Mocha",
        window_background_opacity = 0.95,
      }
    '';
  };
}
