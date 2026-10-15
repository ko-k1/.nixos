# Helium browser (system side). Chromium-based private browser via
# github:oxcl/nix-flake-helium-browser (see flake.nix inputs, wired in
# lib/helpers.nix). Lives here alongside Firefox rather than
# home.packages for system-wide install + policy support.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.helium = {
    enable = true;
    # Helium's wrapper is a binary one (wrapGAppsHook3), so its
    # ${NIXOS_OZONE_WL:+...} flag is never shell-expanded and NIXOS_OZONE_WL
    # has no effect. Pass the Wayland flags explicitly; the IME one keeps
    # fcitx5 working on native Wayland. Both are ignored on X11.
    flags = [
      "--ozone-platform-hint=auto"
      "--enable-wayland-ime=true"
    ];
  };
}
