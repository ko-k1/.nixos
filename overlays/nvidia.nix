# NVIDIA driver: applies an optional kernel-compat patch to
# `config.boot.kernelPackages.nvidiaPackages.stable`.
# Drop patch content into patches/nvidia-driver-kernel.patch to fix a build
# failure against the current kernel. Empty or missing file = no-op.
final: prev:
let
  nvidiaKernelPatch = ../patches/nvidia-driver-kernel.patch;
  hasNvidiaKernelPatch =
    builtins.pathExists nvidiaKernelPatch
    && builtins.stringLength (builtins.readFile nvidiaKernelPatch) > 0;
in
{
  linuxPackages = prev.linuxPackages // {
    nvidiaPackages = prev.linuxPackages.nvidiaPackages // {
      stable = prev.linuxPackages.nvidiaPackages.stable.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ (if hasNvidiaKernelPatch then [ nvidiaKernelPatch ] else [ ]);
      });
    };
  };
}
