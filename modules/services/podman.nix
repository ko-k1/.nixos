{
  config,
  lib,
  pkgs,
  ...
}:
# Live parity: OFF (the running system has docker only). Flip to true
# deliberately if you want podman alongside docker.
{
  virtualisation.podman = {
    enable = false;
    dockerCompat = false;
    dockerSocket.enable = false;
    defaultNetwork.settings.dns_enabled = true;
  };
}
