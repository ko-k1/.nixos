{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    autoPrune.enable = true;
  };
}
