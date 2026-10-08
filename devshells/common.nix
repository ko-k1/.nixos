{ pkgs, packages ? [ ], ... }:
pkgs.mkShell {
  packages =
    with pkgs;
    [
      git
      ripgrep
      fd
      jq
    ]
    ++ packages;
}
