{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.manageLingering = true;

  # Password is set imperatively with `passwd koki` after install.
  users.users.koki = {
    isNormalUser = true;
    description = "koki";
    linger = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
      "docker"
    ];
    packages = with pkgs; [
      tree
    ];
  };
}
