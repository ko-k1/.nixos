# NVIDIA RTX 2080 Ti (Turing). DRM modesetting is required for Wayland.
# `open = false`: Turing works better on the proprietary kernel module.
# The driver package follows the running kernel (`production`, optionally
# patched via patches/nvidia-driver-kernel.patch). `unstable` arrives via flake
# specialArgs.
{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:
let
  # Optional kernel-compat patch: drop content into
  # patches/nvidia-driver-kernel.patch to fix a build failure against the
  # current kernel. Empty or missing file = no-op.
  kernelPatch = ../../patches/nvidia-driver-kernel.patch;
  hasKernelPatch =
    builtins.pathExists kernelPatch && builtins.stringLength (builtins.readFile kernelPatch) > 0;
  driver = config.boot.kernelPackages.nvidiaPackages.production;
in
{
  # Xid 62 freeze mitigations for Turing: preserve VRAM across suspend,
  # enable nvidia-drm fbdev for Wayland, disable GSP firmware offload
  # and PCIe ASPM power-state transitions. GSP-off + ASPM-off alone did
  # NOT stop Xid 62 (still hit 2026-10-09 09:54), so PowerMizer is also
  # pinned to max performance: the always-on GPU load (wallpaperengine +
  # hyprglass) otherwise keeps the card flapping between P-states, the
  # usual Xid 62 trigger. Costs ~20-40 W at idle.
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia_drm.fbdev=1"
    "nvidia.NVreg_EnableGpuFirmware=0"
    "pcie_aspm=off"
    "nvidia.NVreg_RegistryDwords=PowerMizerEnable=0x1;PerfLevelSrc=0x2222;PowerMizerDefault=0x1;PowerMizerDefaultAC=0x1"
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
    package =
      if hasKernelPatch then
        driver.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ kernelPatch ];
        })
      else
        driver;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
