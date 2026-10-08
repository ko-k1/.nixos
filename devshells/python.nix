{ pkgs, ... }:
import ../devshells/common.nix {
  inherit pkgs;
  packages = with pkgs; [
    python3
    uv
    ruff
    mypy
    pyright
  ];
}
