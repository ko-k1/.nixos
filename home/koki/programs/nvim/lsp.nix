{
  config,
  lib,
  pkgs,
  ...
}:
{
  config.koki.nvim.luaConfig = [
    ''
      local lspconfig = require("lspconfig")

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "nil_ls",
          "pyright",
          "gopls",
          "rust_analyzer",
          "typescript-language-server",
        },
        automatic_installation = true,
      })

      require("mason-lspconfig").setup_handlers({
        function(server)
          lspconfig[server].setup({})
        end,
      })
    ''
  ];
}
