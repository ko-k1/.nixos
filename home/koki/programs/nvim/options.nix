{
  config,
  lib,
  pkgs,
  ...
}:
{
  config.koki.nvim.luaConfig = [
    ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true
      vim.opt.smartindent = true
      vim.opt.wrap = false
      vim.opt.swapfile = false
      vim.opt.undofile = true
      vim.opt.hidden = true
      vim.opt.signcolumn = "yes"
      vim.opt.scrolloff = 8
      vim.opt.updatetime = 250
      vim.opt.termguicolors = true
      vim.opt.clipboard = "unnamedplus"
    ''
  ];
}
