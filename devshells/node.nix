{ pkgs, ... }:
import ./common.nix {
  inherit pkgs;
  packages = with pkgs; [
    nodejs_22
    bun
    pnpm
    yarn
    typescript
    typescript-language-server
  ];
}
