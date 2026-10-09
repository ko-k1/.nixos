# Integrated devshell: every language shell merged into one
# (`nix develop .#all`).
{ pkgs, ... }:
pkgs.mkShell {
  inputsFrom = map (name: import ./${name}.nix { inherit pkgs; }) [
    "default"
    "clang"
    "cpp"
    "go"
    "node"
    "python"
    "rust"
  ];
}
