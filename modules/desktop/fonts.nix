{
  config,
  lib,
  pkgs,
  ...
}:
{
  fonts.fontconfig.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts
    noto-fonts-color-emoji
  ];
}
