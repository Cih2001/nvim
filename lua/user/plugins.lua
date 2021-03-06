-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Packer can manage itself
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'mg979/vim-visual-multi', branch = 'master' } -- for having multiple cursors
  use 'preservim/nerdtree'
  use 'Raimondi/delimitMate'
  use 'ryanoasis/vim-devicons'
  use 'kyazdani42/nvim-web-devicons'
  use 'akinsho/bufferline.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'lunarvim/darkplus.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'lewis6991/gitsigns.nvim'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'RRethy/vim-illuminate'
  -- telescope
  use { 'nvim-telescope/telescope-ui-select.nvim' }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use {
    'edolphin-ydf/goimpl.nvim',
    requires = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-telescope/telescope.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
    config = function()
      require 'telescope'.load_extension 'goimpl'
    end,
  }
  -- lsp tools
  use "neovim/nvim-lspconfig" -- enable LSP
  use "williamboman/nvim-lsp-installer" -- simple to use language server installer
  use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
  -- use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
  -- cmp plugins
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "hrsh7th/cmp-nvim-lsp"
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  -- debugging
  use "mfussenegger/nvim-dap"
  use "leoluz/nvim-dap-go"
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
  use "theHamsta/nvim-dap-virtual-text"
  use "nvim-telescope/telescope-dap.nvim"
end)
