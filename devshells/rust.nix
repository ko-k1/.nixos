{ pkgs, ... }:
import ../devshells/common.nix {
  inherit pkgs;
  packages = with pkgs; [
    rustc
    cargo
    rust-analyzer
    clippy
    rustfmt
  ];
}
