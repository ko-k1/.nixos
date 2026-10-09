{
  description = "koki's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    shojiwm = {
      url = "github:bea4dev/ShojiWM";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sonora = {
      url = "github:sonorahq/sonora";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      shojiwm,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = import ./lib { inherit inputs; };
      pkgs = lib.mkPkgs system;

      shell = name: import ./devshells/${name}.nix { inherit pkgs; };
    in
    {
      nixosConfigurations = {
        h4ck1ng-h0st = lib.mkSystem {
          host = "h4ck1ng-h0st";
          home = "koki";
          inherit system;
        };
      };

      homeConfigurations = {
        koki = lib.mkHome {
          user = "koki";
          inherit system;
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

      # nixpkgs-fmt is deprecated/archived; nixfmt is the official formatter.
      # The wrapper defaults bare `nix fmt` to all git-tracked *.nix files
      # (nixfmt >= 1.4 no longer accepts a bare invocation).
      formatter.${system} = pkgs.writeShellScriptBin "nixfmt" ''
        if [ "$#" -eq 0 ]; then
          # shellcheck disable=SC2207
          files=( $(git ls-files '*.nix' 2>/dev/null) )
          [ "''${#files[@]}" -eq 0 ] && files=( . )
          set -- "''${files[@]}"
        fi
        exec ${pkgs.nixfmt}/bin/nixfmt "$@"
      '';
    };
}
