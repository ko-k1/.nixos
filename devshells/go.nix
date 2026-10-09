{ pkgs, ... }:
import ./common.nix {
  inherit pkgs;
  packages = with pkgs; [
    go
    go-tools
    golangci-lint
    gopls
    delve
  ];
}
