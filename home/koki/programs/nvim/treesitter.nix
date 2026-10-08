{
  config,
  lib,
  pkgs,
  ...
}:
{
  config.koki.nvim.luaConfig = [
    ''
      require("nvim-treesitter").setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
    ''
  ];
}
