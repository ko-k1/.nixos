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
    linux-wallpaperengine
  ];
}
