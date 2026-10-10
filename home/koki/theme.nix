# Catppuccin Mocha (Blue accent) desktop theme: GTK 3/4, Qt 5/6 (Kvantum),
# icons and cursor. App colours (rofi, btop, ...) stay in dotfiles/ and use
# the same flavor; terminals intentionally keep their black backgrounds.
{ config, pkgs, ... }:
let
  flavor = "mocha";
  accent = "blue";
in
{
  fonts.fontconfig.enable = true;

  # catppuccin/nix: only the ports listed here, never auto-enrolled, so it
  # does not touch configs managed from dotfiles/.
  catppuccin = {
    enable = true;
    autoEnable = false;
    inherit flavor accent;
    kvantum.enable = true;
    # Papirus-Dark with Catppuccin-coloured folders (sets gtk.iconTheme).
    gtk.icon.enable = true;
  };

  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      name = "catppuccin-${flavor}-${accent}-standard";
      package = pkgs.catppuccin-gtk.override {
        variant = flavor;
        accents = [ accent ];
      };
    };
    # Not inherited from gtk.theme for GTK4; this makes HM write
    # gtk-4.0/gtk.css importing the theme (libadwaita ignores the name).
    gtk4.theme = config.gtk.theme;
  };

  # libadwaita / GTK4 apps and the portal read the dark preference from
  # dconf, not from gtk-theme-name (programs.dconf is enabled system-side).
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = config.gtk.theme.name;
    icon-theme = config.gtk.iconTheme.name;
    cursor-theme = config.home.pointerCursor.name;
    cursor-size = config.home.pointerCursor.size;
  };

  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursor-themes;
    size = 24;
    x11.enable = true;
    gtk.enable = true;
    hyprcursor.enable = true;
  };

  # Kvantum for both platform theme and style; the qt module installs the
  # Qt5 + Qt6 plugins and exports QT_QPA_PLATFORMTHEME / QT_STYLE_OVERRIDE.
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
  };
}
