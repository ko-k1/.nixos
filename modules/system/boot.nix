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

  # Safety net for memory pressure + Magic SysRq for hung GPU recovery.
  zramSwap.enable = true;
  zramSwap.memoryPercent = 25;
  boot.kernel.sysctl."kernel.sysrq" = 1;
}
