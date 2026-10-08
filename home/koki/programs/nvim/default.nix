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
    ./editor.nix
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
      # Tools on PATH for the editor: finders + all language servers
      # (managed by Nix, see lsp.nix — no Mason).
      extraPackages = with pkgs; [
        ripgrep
        fd
        lua-language-server
        nil
        pyright
        gopls
        rust-analyzer
        typescript-language-server
      ];
      plugins = cfg.plugins;
      initLua = lib.concatStringsSep "\n" cfg.luaConfig;
    };
  };
}
