{
  inputs,
}:
let
  inherit (inputs)
    nixpkgs
    nixpkgs-unstable
    home-manager
    shojiwm
    ;

  # Single source of nixpkgs config for every pkgs instance (NixOS module
  # path, standalone home-manager, flake devShells/formatter).
  nixpkgsConfig = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "openssl-1.1.1w"
    ];
  };

  overlays = [ (import ../overlays) ];

  mkUnstable =
    system:
    import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

  mkPkgs =
    system:
    import nixpkgs {
      inherit system overlays;
      config = nixpkgsConfig;
    };
in
{
  inherit mkPkgs;

  mkSystem =
    {
      host,
      home,
      system ? "x86_64-linux",
      user ? "koki",
      extraModules ? [ ],
      extraSpecialArgs ? { },
    }:
    let
      unstable = mkUnstable system;
    in
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs unstable;
      }
      // extraSpecialArgs;
      modules = [
        {
          nixpkgs.overlays = overlays;
          nixpkgs.config = nixpkgsConfig;
        }
        (../hosts/${host}/default.nix)
        shojiwm.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            # Move conflicting unmanaged files to *.backup instead of
            # failing the whole switch.
            backupFileExtension = "backup";
            users.${user} = import (../home/${home}/default.nix);
            extraSpecialArgs = {
              inherit unstable;
            }
            // extraSpecialArgs;
          };
        }
      ]
      ++ extraModules;
    };

  mkHome =
    {
      user,
      system ? "x86_64-linux",
      extraModules ? [ ],
      extraSpecialArgs ? { },
    }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs system;
      extraSpecialArgs = {
        unstable = mkUnstable system;
      }
      // extraSpecialArgs;
      modules = [ (../home/${user}/default.nix) ] ++ extraModules;
    };
}
