{
  config,
  lib,
  pkgs,
  ...
}:
{
   imports = [
     ../../modules/system/users.nix
     ../../modules/desktop/audio.nix
     ../../modules/desktop/fonts.nix
     ../../modules/desktop/hyprland.nix
     ../../modules/desktop/niri.nix
     ../../modules/desktop/waybar.nix
     ../../modules/development/git.nix
     ../../modules/development/languages.nix
     ../../modules/development/tool.nix
     ../../modules/hardware/amd.nix
     ../../modules/services/docker.nix
     ../../modules/services/podman.nix
     ../../modules/services/ssh.nix
     ../../modules/system/boot.nix
     ../../modules/system/locale.nix
     ../../modules/system/networking.nix
     ../../modules/system/security.nix
   ];

  networking.hostName = "h4ck1ng-h0st";

  system.stateVersion = "26.05";
}
