# Composed overlay: local packages + upstream fixes.
# Each file is a single `final: prev:` overlay; order here is the
# application order (later entries win on conflict).
final: prev:
let
  compose = prev.lib.composeManyExtensions [
    (import ./ly.nix)
    (import ./nvidia.nix)
    (import ./waybar.nix)
    (import ./bibata.nix)
    (final: prev: {
      my-package = final.callPackage ../pkgs/my-package { };
      # NOTE: named `myScripts`, not `scripts` — a top-level `scripts`
      # attr leaks into every `callPackage` and breaks packages that take
      # a `scripts` argument (e.g. mpv).
      myScripts = final.callPackage ../pkgs/scripts.nix { };
    })
  ];
in
compose final prev
