{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/nix.nix
    ../../modules/system/boot.nix
    ../../modules/system/locale.nix
    ../../modules/system/networking.nix
    ../../modules/system/packages.nix
    ../../modules/system/security.nix
    ../../modules/system/users.nix
    ../../modules/desktop/audio.nix
    ../../modules/desktop/fonts.nix
    ../../modules/desktop/portal.nix
    ../../modules/desktop/ly.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/niri.nix
    ../../modules/desktop/shojiwm.nix
    ../../modules/development/git.nix
    ../../modules/development/languages.nix
    ../../modules/development/tool.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/programs/gaming.nix
    ../../modules/services/docker.nix
    ../../modules/services/podman.nix
    ../../modules/services/printing.nix
    ../../modules/services/ollama.nix
    ../../modules/services/sunshine.nix
    ../../modules/services/ssh.nix
  ];

  networking.hostName = "h4ck1ng-h0st";

  system.stateVersion = "26.05";
}
