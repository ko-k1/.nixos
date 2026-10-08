{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "26.05";
}
