{ pkgs, ... }:
{
  nix-rebuild = pkgs.writeShellScriptBin "nix-rebuild" ''
    # Absolute repo path so rebuilds work from any cwd (repo is the
    # single source of truth; ~/nixos-config is retired).
    exec sudo nixos-rebuild switch --flake /home/koki/src/.nixos#h4ck1ng-h0st "$@"
  '';

  nix-check = pkgs.writeShellScriptBin "nix-check" ''
    exec nix flake check "$@"
  '';
}
