{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.koki = {
    isNormalUser = true;
    description = "koki";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "audio"
      "video"
      "input"
    ];
  };
}
