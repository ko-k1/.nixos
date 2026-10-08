{ pkgs, ... }:
import ../devshells/common.nix {
  inherit pkgs;
  packages = with pkgs; [
    nodejs_22
    pnpm
    yarn
    typescript
    typescript-language-server
  ];
}
