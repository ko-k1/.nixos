# Sunshine game streaming host for Moonlight (user unit, starts on
# graphical-session). Web UI stays editable: settings/applications are
# intentionally left unset so ~/.config/sunshine/ remains writable.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # required for DRM/KMS capture on Wayland/NVIDIA
    openFirewall = true;
  };
}
