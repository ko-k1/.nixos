{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.koki.nvim;
in
{
  imports = [
    ./completion.nix
    ./keymap.nix
    ./lsp.nix
    ./options.nix
    ./plugins.nix
    ./treesitter.nix
  ];

  options.koki.nvim = {
    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };
    luaConfig = lib.mkOption {
      type = lib.types.listOf lib.types.lines;
      default = [ ];
    };
  };

  config = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      extraPackages = [ pkgs.ripgrep pkgs.fd ];
      plugins = cfg.plugins;
      initLua = lib.concatStringsSep "\n" cfg.luaConfig;
    };
  };
}
