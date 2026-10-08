{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    dockerSocket.enable = false;
    defaultNetwork.settings.dns_enabled = true;
  };
}
