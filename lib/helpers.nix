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
in
{
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
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs unstable;
      }
      // extraSpecialArgs;
      modules = [
        {
          nixpkgs.overlays = [ (import ../overlays) ];
          nixpkgs.config.allowUnfree = true;
        }
        (../hosts/${host}/default.nix)
        (../hosts/${host}/hardware-configuration.nix)
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
    let
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        # Keep in sync with modules/system/packages.nix: the NixOS module
        # path sets this via nixpkgs.config, but standalone home-manager
        # builds (home-manager switch --flake .#koki) need it here.
        config.permittedInsecurePackages = [
          "openssl-1.1.1w"
        ];
        overlays = [ (import ../overlays) ];
      };
    in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit unstable;
      }
      // extraSpecialArgs;
      modules = [ (../home/${user}/default.nix) ] ++ extraModules;
    };
}
