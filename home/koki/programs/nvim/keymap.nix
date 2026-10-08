{
  config,
  lib,
  pkgs,
  ...
}:
{
  config.koki.nvim.luaConfig = [
    ''
      local map = vim.keymap.set

      map("n", "<leader>e", "<cmd>Ex<CR>", { desc = "File explorer" })
      map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
      map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
      map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
      map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
      map("i", "jj", "<Esc>", { desc = "Exit insert mode" })

      map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
      map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
      map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
      map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

      map("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
      map("n", "gr", vim.lsp.buf.references, { desc = "References" })
      map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
      map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
    ''
  ];
}
