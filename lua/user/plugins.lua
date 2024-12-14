require("lazy").setup({
	-- Treesitter
	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
		lazy = true,
	},
	"nvim-treesitter/nvim-treesitter-textobjects",

	-- misc
	"mg979/vim-visual-multi",
	"lukas-reineke/indent-blankline.nvim",
	"RRethy/vim-illuminate",
	"lewis6991/gitsigns.nvim",
	{
		"sindrets/diffview.nvim",
		lazy = true,
		cmd = { "DiffviewOpen" },
	},
	{
		"lewis6991/satellite.nvim",
		config = function()
			require("satellite").setup({
				handlers = {
					gitsigns = {
						enable = false,
					},
				},
			})
		end,
	},
	{
		"sphamba/smear-cursor.nvim",
		opts = {},
	},

	"nvim-lualine/lualine.nvim",

	-- nvimtree
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	},

	-- harpoon
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim", "rafcamlet/tabline-framework.nvim" },
	},

	-- color themes
	"Mofiqul/vscode.nvim",

	-- fuzzy finders
	"ibhagwan/fzf-lua",

	-- code review
	{
		"pwntester/octo.nvim",
		lazy = true,
		cmd = "Octo",
		config = function()
			require("user.octo")
		end,
	},

	-- lsp tools
	"neovim/nvim-lspconfig", -- enable LSP
	"williamboman/mason.nvim", -- in charge of managing lsp servers, linters & formatters
	"williamboman/mason-lspconfig.nvim", -- bridges gap b/w mason & lspconfig
	"hrsh7th/nvim-cmp", -- The completion plugin
	"hrsh7th/cmp-buffer", -- buffer completions
	"hrsh7th/cmp-path", -- path completions
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	"L3MON4D3/LuaSnip", --snippet engine, used for snippets and parameters place holders.
	{
		"smjonas/inc-rename.nvim",
		init = function()
			require("inc_rename").setup()
		end,
	},

	-- formatters and linters
	"stevearc/conform.nvim",
	"mfussenegger/nvim-lint",

	-- debugging
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},
		lazy = true,
		config = function()
			require("user.dap")
		end,
	},

	-- tmux integration
	"christoomey/vim-tmux-navigator",

	-- markdown-preview
	{
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		lazy = true,
	},

	-- auto closing
	"windwp/nvim-autopairs", -- autoclose parens, brackets, quotes, etc...

	-- db
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "tpope/vim-dadbod", "kristijanhusak/vim-dadbod-completion" },
		lazy = true,
		cmd = "DBUI",
	},

	-- chat gpt
	{
		"robitx/gp.nvim",
		config = function()
			require("gp").setup()
		end,
		lazy = true,
		keys = {
			{ "<leader>c", "<cmd>GpChatToggle<cr>", desc = "Open chat gpt" },
		},
	},
})
