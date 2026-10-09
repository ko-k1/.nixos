{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./packages.nix
    ./theme.nix
    ./git.nix
    ./shell.nix
    ./tmux.nix
    ./hyprland.nix
    ./niri.nix
    ./waybar.nix
    ./zsuggestion.nix
    ./mutable.nix
    ./apps.nix
    ./programs/alacritty.nix
    ./programs/foot.nix
    ./programs/kitty.nix
    ./programs/wezterm.nix
    ./programs/starship.nix
    ./programs/nvim
  ];

  home.username = "koki";
  home.homeDirectory = "/home/koki";

  home.stateVersion = "26.05";
}
