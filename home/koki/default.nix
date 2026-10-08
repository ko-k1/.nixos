{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./git.nix
    ./shell.nix
    ./tmux.nix
    ./zsh.nix
    ./programs/alacritty.nix
    ./programs/kitty.nix
    ./programs/wezterm.nix
    ./programs/starship.nix
    ./programs/nvim
  ];

  home.username = "koki";
  home.homeDirectory = "/home/koki";

  home.stateVersion = "26.05";
}
