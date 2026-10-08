# System-wide git defaults. Per-user identity/aliases live in
# home/koki/git.nix.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
  };
}
