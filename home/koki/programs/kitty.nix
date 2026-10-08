{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 11.0;
      background_opacity = "0.95";
      cursor_shape = "block";
      confirm_os_window_close = 0;
    };
    keybindings = {
      "ctrl+shift+left" = "previous_window";
      "ctrl+shift+right" = "next_window";
    };
  };
}
