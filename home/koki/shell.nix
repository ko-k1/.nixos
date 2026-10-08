{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    scripts.nix-rebuild
    scripts.nix-check
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
  };

  home.shellAliases = {
    ll = "ls -lah";
    la = "ls -la";
    l = "ls -l";
    rebuild = "nix-rebuild";
    check = "nix-check";
  };
}
