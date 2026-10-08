# Pure Nix-managed LSPs: servers come from `extraPackages` (default.nix),
# no Mason, no runtime downloads. Uses Neovim's built-in `vim.lsp`
# API (0.11+); nvim-lspconfig stays installed as a config fallback.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config.koki.nvim.luaConfig = [
    ''
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.enable({
        "lua_ls",
        "nil_ls",
        "pyright",
        "gopls",
        "rust_analyzer",
        "ts_ls",
      })
    ''
  ];
}
