{
  pkgs,
  ...
}:
{
  imports = [
    # lazyvim.homeManagerModules.default is already imported as a sharedModule
    # in lib/helpers.nix, so we only need to configure programs.lazyvim here.
  ];

  # programs.lazyvim enables programs.neovim itself; keep the aliases and
  # $EDITOR the previous hand-rolled config provided.
  programs.neovim = {
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.lazyvim = {
    enable = true;

    # LazyVim extras for the languages in use. Lua is enabled by default.
    extras = {
      lang.nix.enable = true;
      lang.python.enable = true;
      lang.go.enable = true;
      lang.rust.enable = true;
      lang.typescript.enable = true;
    };

    # Mason is disabled by lazyvim-nix, so every LSP server, formatter and
    # linter the enabled extras call must come from Nix (ripgrep, fd, fzf,
    # lazygit come in via installCoreDependencies).
    extraPackages = with pkgs; [
      # lua (core)
      lua-language-server
      stylua
      # sh (core conform)
      shfmt
      # lang.nix
      nil
      nixfmt
      statix
      # lang.python
      pyright
      ruff
      # lang.go
      gopls
      gofumpt
      gotools
      # lang.rust (rustaceanvim)
      rust-analyzer
      # lang.typescript
      vtsls
    ];

    config = {
      options = ''
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
      '';

      # LazyVim already maps <leader>e (explorer), <leader>ff / <leader>fb
      # (snacks picker), <C-hjkl> window moves and gd/gr/K (buffer-local LSP).
      # Telescope isn't installed, so only add what LazyVim lacks.
      keymaps = ''
        vim.keymap.set("n", "<leader>fg", function() LazyVim.pick("live_grep")() end, { desc = "Live grep" })
        vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
        vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
      '';
    };

    plugins = {
      colorscheme = ''
        return {
          {
            "catppuccin/nvim",
            name = "catppuccin",
            opts = { flavour = "mocha" },
          },
          {
            "LazyVim/LazyVim",
            opts = { colorscheme = "catppuccin" },
          },
        }
      '';
    };
  };
}
