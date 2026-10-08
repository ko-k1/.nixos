{
  config,
  lib,
  pkgs,
  ...
}:
{
  hardware.graphics.enable = true;
  hardware.amdgpu.initrd.enable = true;

  environment.systemPackages = with pkgs; [
    mesa-demos
    vulkan-tools
  ];
}
