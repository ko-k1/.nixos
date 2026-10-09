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
      font_family = "FantasqueSansM Nerd Font Mono Bold";
      font_size = "14.0";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      background_opacity = "0.4";
      dynamic_background_opacity = "1";
      confirm_os_window_close = "0";

      cursor_trail = "1";
      cursor_shape = "underline";

      linux_display_server = "auto";

      scrollback_lines = "10000";
      wheel_scroll_min_lines = "1";

      enable_audio_bell = "no";

      window_padding_width = "10";

      selection_foreground = "none";
      selection_background = "none";

      foreground = "#dddddd";
      background = "#000000";
      cursor = "#dddddd";

      shell = "zsh";

      # Powerline tabs + battery/clock, drawn by tab_bar.py below.
      tab_bar_style = "custom";
    };
  };

  xdg.configFile."kitty/tab_bar.py".source = ../dotfiles/kitty/tab_bar.py;
}
