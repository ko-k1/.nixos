{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Interactive connections via nmcli/nmtui.
  networking.networkmanager.enable = true;

  services.resolved.enable = true;

  # Firewall on; per-service ports (ssh, sunshine) are opened by their own
  # modules via `openFirewall` / `allowedTCPPorts`.
  networking.firewall.enable = true;
}
