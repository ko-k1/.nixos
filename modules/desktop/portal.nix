# Shared xdg-desktop-portal / Wayland session base. Compositor backends
# come from their own programs.* options (hyprland pins portalPackage from
# unstable); this file only owns `enable` + the gtk fallback so backends
# never fight over the same option, plus compositor-agnostic session env.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  # dconf backs the GTK/libadwaita settings written by home/koki/theme.nix
  # (color-scheme, gtk/icon/cursor theme) and read by the gtk portal.
  programs.dconf.enable = true;

  # Run Chromium/Electron apps natively on Wayland. nixpkgs wrappers
  # (chromium, vscode, equibop, claude-desktop, ...; not Helium, see
  # modules/programs/helium.nix) read this and add
  # --ozone-platform-hint=auto plus --enable-wayland-ime for fcitx5.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
