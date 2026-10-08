# Starship prompt. The actual theme is home/koki/starship.toml (Catppuccin
# Mocha); this module only loads it so the TOML stays editable as data.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ../starship.toml);
  };
}
