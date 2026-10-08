{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking.networkmanager.enable = true;

  services.resolved.enable = true;

  networking.firewall = {
    enable = true;
  };
}
