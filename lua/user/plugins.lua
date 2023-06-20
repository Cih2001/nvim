-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])
return require("packer").startup(function()
	use("wbthomason/packer.nvim") -- Packer can manage itself

	-- Treesitter
	use({
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		run = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
	})
	use({ -- Additional text objects via treesitter
		"nvim-treesitter/nvim-treesitter-textobjects",
	})

	-- Misc
	use({ "mg979/vim-visual-multi", branch = "master" }) -- for having multiple cursors
	use("ryanoasis/vim-devicons")
	use("nvim-tree/nvim-web-devicons")
	use("nvim-lua/plenary.nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use("RRethy/vim-illuminate")
	use("lewis6991/gitsigns.nvim")
	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })
	use({ "rafcamlet/tabline-framework.nvim", requires = "nvim-tree/nvim-web-devicons" })
	use("nvim-lualine/lualine.nvim")
	use("ggandor/leap.nvim")

	-- neo tree
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
	})

	-- harpoon
	use({
		"ThePrimeagen/harpoon",
		requires = { "nvim-lua/plenary.nvim" },
	})

	-- color themes
	-- use 'lunarvim/darkplus.nvim'
	use("Cih2001/darkplus.nvim")

	-- fuzzy finders
	use({ "nvim-telescope/telescope-ui-select.nvim" })
	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})
	use({
		"ibhagwan/fzf-lua",
		-- optional for icon support
		requires = { "nvim-tree/nvim-web-devicons" },
	})

	-- code review
	use({
		"pwntester/octo.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
	})

	-- lsp tools
	use("neovim/nvim-lspconfig") -- enable LSP
	use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
	use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig
	use("tamago324/nlsp-settings.nvim") -- language server settings defined in json for
	use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters

	-- cmp plugins
	use("hrsh7th/nvim-cmp") -- The completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lsp-signature-help")
	use("saadparwaiz1/cmp_luasnip") -- snippet completions

	-- snippets
	use("L3MON4D3/LuaSnip") --snippet engine
	-- debugging
	use("mfussenegger/nvim-dap")
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
	use("theHamsta/nvim-dap-virtual-text")
	use("nvim-telescope/telescope-dap.nvim")
	-- tmux integration
	use("christoomey/vim-tmux-navigator")
	-- swagger
	use("xavierchow/vim-swagger-preview")
	-- markdown-preview
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	})

	-- auto closing
	use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

	-- db
	use("tpope/vim-dadbod")
	use("kristijanhusak/vim-dadbod-ui")

	-- chat gpt
	use({
		"jackMort/ChatGPT.nvim",
		requires = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	})
end)
