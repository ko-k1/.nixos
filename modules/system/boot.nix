{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # /tmp as tmpfs (clean on every boot, no disk wear).
  boot.tmp.useTmpfs = true;
}
