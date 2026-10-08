{
  config,
  lib,
  pkgs,
  ...
}:
{
  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
