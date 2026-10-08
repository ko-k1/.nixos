{ pkgs, ... }:
{
  nix-rebuild = pkgs.writeShellScriptBin "nix-rebuild" ''
    exec sudo nixos-rebuild switch --flake .#h4ck1ng-h0st "$@"
  '';

  nix-check = pkgs.writeShellScriptBin "nix-check" ''
    exec nix flake check "$@"
  '';
}
