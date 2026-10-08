# Desktop apps that need system-level integration (setuid, wrappers,
# xdg portals) rather than a plain user install.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.wireshark.enable = true;
}
