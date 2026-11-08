{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Always-available rescue tools in the system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    less
    gnutar
    gzip
    bzip2
    xz
    rsync
    linux-firmware
    linux-wallpaperengine
    polkit
  ];
}
