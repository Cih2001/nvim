-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function()
  use 'wbthomason/packer.nvim'                                  -- Packer can manage itself
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } 
  use { 'mg979/vim-visual-multi', branch = 'master' }           -- for having multiple cursors
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
end)
