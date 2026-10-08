{
  inputs,
}:
let
  inherit (inputs) nixpkgs home-manager;
in
{
  mkSystem =
    {
      host,
      home,
      system ? "x86_64-linux",
      overlays ? { },
      extraModules ? [ ],
      user ? "koki",
    }:
    let
      hostDir = ../hosts/${host};
      homeDir = ../home/${home};
    in
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        [
          {
            nixpkgs.overlays = nixpkgs.lib.attrValues overlays;
          }
          (hostDir + "/default.nix")
          (hostDir + "/hardware-configuration.nix")
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user} = import (homeDir + "/default.nix");
            };
          }
        ]
        ++ extraModules;
    };

  mkHome =
    {
      user,
      system ? "x86_64-linux",
      overlays ? { },
      extraModules ? [ ],
    }:
    let
      homeDir = ../home/${user};
      pkgs = (nixpkgs.legacyPackages.${system}).extend (
        nixpkgs.lib.composeManyExtensions (nixpkgs.lib.attrValues overlays)
      );
    in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ (homeDir + "/default.nix") ] ++ extraModules;
    };
}
