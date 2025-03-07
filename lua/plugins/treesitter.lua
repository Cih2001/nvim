return {
	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
		lazy = true,
		config = function(_, opts)
			local configs = require("nvim-treesitter.configs")

			configs.setup(opts)

			local group_id = vim.api.nvim_create_augroup("open_folds", { clear = true })
			vim.api.nvim_create_autocmd({ "BufWinEnter", "BufReadPost", "FileReadPost" }, {
				group = group_id,
				pattern = { "*.lua", "*.go", "*.yaml", "*.yml" },
				command = "normal zR",
			})
		end,
		opts = {
			sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
			ensure_installed = { "c", "lua", "vim", "vimdoc", "cpp", "python", "go", "hcl" },
			ignore_install = { "" }, -- List of parsers to ignore installing
			autopairs = {
				enable = true,
			},
			highlight = {
				enable = true, -- false will disable the whole extension
				disable = { "yaml" }, -- list of language that will be disabled
				additional_vim_regex_highlighting = true,
			},
			indent = { enable = false },
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
			incremental_selection = {
				enable = false,
				-- keymaps = {
				-- 	init_selection = "<c-s>",
				-- 	node_incremental = "<c-s>",
				-- 	scope_incremental = "<c-s>",
				-- 	node_decremental = "<c-backspace>",
				-- },
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]]"] = "@function.outer",
						["]a"] = "@parameter.inner",
					},
					goto_next_end = {
						["]["] = "@function.outer",
					},
					goto_previous_start = {
						["[["] = "@function.outer",
						["[a"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[]"] = "@function.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["ss"] = "@parameter.inner",
					},
					swap_previous = {
						["sd"] = "@parameter.inner",
					},
				},
			},
		},
	},
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
}
