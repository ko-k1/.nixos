{
  inputs,
}:
let
  inherit (inputs)
    nixpkgs
    nixpkgs-unstable
    home-manager
    shojiwm
    sonora
    catppuccin
    claude-desktop
    helium-browser
    lazyvim
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
        claude-desktop.nixosModules.default
        helium-browser.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            # Move conflicting unmanaged files to *.backup instead of
            # failing the whole switch.
            backupFileExtension = "backup";
            sharedModules = [
              sonora.homeManagerModules.default
              catppuccin.homeModules.catppuccin
              lazyvim.homeManagerModules.default
            ];
            users.${user} = import (../home/${home}/default.nix);
            extraSpecialArgs = {
              inherit unstable lazyvim;
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
      unstable = mkUnstable system;
    in
    home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs system;
      extraSpecialArgs = {
        inherit unstable lazyvim;
      }
      // extraSpecialArgs;
      modules = [
        sonora.homeManagerModules.default
        catppuccin.homeModules.catppuccin
        lazyvim.homeManagerModules.default
        (../home/${user}/default.nix)
      ]
      ++ extraModules;
    };
}
