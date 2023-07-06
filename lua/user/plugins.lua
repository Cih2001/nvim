vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
	-- Treesitter
	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	},

	"nvim-treesitter/nvim-treesitter-textobjects",
	-- requirements
	"nvim-tree/nvim-web-devicons",
	"nvim-lua/plenary.nvim",
	"ryanoasis/vim-devicons",
	"MunifTanjim/nui.nvim",

	-- misc
	"mg979/vim-visual-multi",
	"lukas-reineke/indent-blankline.nvim",
	"RRethy/vim-illuminate",
	"lewis6991/gitsigns.nvim",
	"sindrets/diffview.nvim",
	"rafcamlet/tabline-framework.nvim",
	"nvim-lualine/lualine.nvim",
	"ggandor/leap.nvim",

	-- neotree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
	},

	-- harpoon
	"ThePrimeagen/harpoon",

	-- color themes
	"Cih2001/darkplus.nvim",

	-- fuzzy finders
	{ "nvim-telescope/telescope-ui-select.nvim", lazy = true },
	{ "nvim-telescope/telescope.nvim", lazy = true },
	{ "ibhagwan/fzf-lua", lazy = true },

	-- code review
	{ "pwntester/octo.nvim", lazy = true },

	-- lsp tools
	"neovim/nvim-lspconfig", -- enable LSP
	"williamboman/mason.nvim", -- in charge of managing lsp servers, linters & formatters
	"williamboman/mason-lspconfig.nvim", -- bridges gap b/w mason & lspconfig
	"tamago324/nlsp-settings.nvim", -- language server settings defined in json for
	"jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
	"hrsh7th/nvim-cmp", -- The completion plugin
	"hrsh7th/cmp-buffer", -- buffer completions
	"hrsh7th/cmp-path", -- path completions
	"hrsh7th/cmp-cmdline", -- cmdline completions
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	"saadparwaiz1/cmp_luasnip", -- snippet completions
	"L3MON4D3/LuaSnip", --snippet engine

	-- debugging
	"mfussenegger/nvim-dap",
	"rcarriga/nvim-dap-ui",
	"theHamsta/nvim-dap-virtual-text",

	-- tmux integration
	"christoomey/vim-tmux-navigator",
	-- swagger
	{ "xavierchow/vim-swagger-preview", lazy = true },
	-- markdown-preview
	{
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
	},

	-- auto closing
	"windwp/nvim-autopairs", -- autoclose parens, brackets, quotes, etc...
	"windwp/nvim-ts-autotag",
	-- db
	"tpope/vim-dadbod",
	"kristijanhusak/vim-dadbod-ui",
	-- chat gpt
	"jackMort/ChatGPT.nvim",
})
