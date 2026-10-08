{
  description = "koki's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = (nixpkgs.legacyPackages.${system}).extend (import ./overlays);

      lib = import ./lib { inherit inputs; };

      shell = name: import ./devshells/${name}.nix { inherit pkgs; };
    in
    {
      nixosConfigurations = {
        h4ck1ng-h0st = lib.mkSystem {
          host = "h4ck1ng-h0st";
          home = "koki";
          overlays = self.outputs.overlays;
        };
      };

      homeConfigurations = {
        koki = lib.mkHome {
          user = "koki";
          overlays = self.outputs.overlays;
        };
      };

      devShells.${system} = {
        default = shell "default";
        clang = shell "clang";
        cpp = shell "cpp";
        go = shell "go";
        node = shell "node";
        python = shell "python";
        rust = shell "rust";
      };

      overlays = {
        default = import ./overlays;
      };

      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
