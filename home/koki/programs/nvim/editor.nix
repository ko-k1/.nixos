# setup() calls for plugins that are installed but inert without them.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config.koki.nvim.luaConfig = [
    ''
      require("telescope").setup({})
      pcall(require("telescope").load_extension, "fzf")

      require("nvim-autopairs").setup({})
      require("gitsigns").setup({})
      require("Comment").setup({})
      require("nvim-web-devicons").setup({})
    ''
  ];
}
