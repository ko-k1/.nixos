{ pkgs, ... }:
import ./common.nix {
  inherit pkgs;
  packages = with pkgs; [
    curl
    wget
    tree
    tldr
    unzip
    my-package
    myScripts.nix-rebuild
    myScripts.nix-check
  ];
}
