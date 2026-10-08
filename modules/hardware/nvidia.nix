# NVIDIA RTX 2080 Ti (Turing). DRM modesetting is required for Wayland.
# `open = false`: Turing works better on the proprietary kernel module.
# The driver package follows the running kernel (`stable`, optionally
# patched via overlays/nvidia.nix).
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
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
