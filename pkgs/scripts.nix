{ pkgs, ... }:
{
  nix-rebuild = pkgs.writeShellScriptBin "nix-rebuild" ''
    # Absolute repo path so rebuilds work from any cwd. The `nxrb` shell
    # alias calls this script, so this is the only place the path lives.
    exec sudo nixos-rebuild switch --flake /home/koki/.nixos#h4ck1ng-h0st "$@"
  '';

  nix-check = pkgs.writeShellScriptBin "nix-check" ''
    exec nix flake check "$@"
  '';
}
