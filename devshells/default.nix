{ pkgs, ... }:
import ../devshells/common.nix {
  inherit pkgs;
  packages = with pkgs; [
    curl
    wget
    tree
    tldr
    unzip
    my-package
    scripts.nix-rebuild
    scripts.nix-check
  ];
}
