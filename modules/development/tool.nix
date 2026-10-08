# direnv + nix-direnv: `.envrc` (`use flake`) gives per-directory
# devshells. Pairs with devshells/common.nix.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
