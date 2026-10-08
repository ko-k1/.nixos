# Run unpatched dynamic binaries (VSCode servers, Mason leftovers, etc.)
# without FHS wrappers.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.nix-ld.enable = true;
}
