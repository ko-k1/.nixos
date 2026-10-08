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
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.fira-code
    hackgen-nf-font
    noto-fonts
    noto-fonts-color-emoji
  ];
}
