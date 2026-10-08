{
  config,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  # Always-available rescue tools in the system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    linux-wallpaperengine
  ];
}
