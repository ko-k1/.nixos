{ pkgs, ... }:
import ../devshells/common.nix {
  inherit pkgs;
  packages = with pkgs; [
    clang
    llvm
    lldb
    cmake
    ninja
    pkg-config
  ];
}
