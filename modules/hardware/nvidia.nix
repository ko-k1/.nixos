# NVIDIA RTX 2080 Ti (Turing). DRM modesetting is required for Wayland.
# `open = false`: Turing works better on the proprietary kernel module.
# The driver package follows the running kernel (`production`, optionally
# patched via overlays/nvidia.nix). `unstable` arrives via flake
# specialArgs.
{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:
{
  # Xid 62 freeze mitigations for Turing: preserve VRAM across suspend,
  # enable nvidia-drm fbdev for Wayland, disable GSP firmware offload
  # (top Xid 62 suspect) and PCIe ASPM power-state transitions.
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia_drm.fbdev=1"
    "nvidia.NVreg_EnableGpuFirmware=0"
    "pcie_aspm=off"
  ];

  hardware.graphics.enable = true;
  # Mesa must come from the same nixpkgs as Hyprland to avoid lag/FPS
  # drops from a driver/compositor version mismatch.
  hardware.graphics.package = unstable.mesa;
  hardware.graphics.package32 = unstable.pkgsi686Linux.mesa;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    # production is more stable than stable (595.71.05) for Turing Xid 62.
    # Revert to .stable if production causes build issues with kernel 6.18.
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
