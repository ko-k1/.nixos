{ pkgs, ... }:
import ./common.nix {
  inherit pkgs;
  packages = with pkgs; [
    gcc
    gdb
    cmake
    ninja
    pkg-config
    cppcheck
  ];
}
