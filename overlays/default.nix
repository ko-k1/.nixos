final: prev: {
  my-package = final.callPackage ../pkgs/my-package { };
  scripts = final.callPackage ../pkgs/scripts.nix { };
}
