{
  config,
  lib,
  pkgs,
  ...
}:
{
  security.sudo.wheelNeedsPassword = false;

  security.rtkit.enable = true;
}
