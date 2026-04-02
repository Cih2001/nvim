return {
	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- lazy-loading is not supported by the new API
		build = ":TSUpdate",
		config = function()
			-- Install parsers (async, no-op if already installed)
			require("nvim-treesitter").install({ "c", "lua", "vim", "vimdoc", "cpp", "python", "go", "hcl", "yaml" })

			-- Enable treesitter highlighting and folding per filetype
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					-- Highlighting (replaces the old highlight.enable = true)
					local ok = pcall(vim.treesitter.start)
					if not ok then
						return
					end

					-- Treesitter-based folding (replaces the old fold integration)
					vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo[0][0].foldmethod = "expr"
					vim.wo[0][0].foldlevel = 99 -- open all folds by default
				end,
			})

			-- Open all folds when entering certain file types (preserves original behavior)
			local group_id = vim.api.nvim_create_augroup("open_folds", { clear = true })
			vim.api.nvim_create_autocmd({ "BufWinEnter", "BufReadPost", "FileReadPost" }, {
				group = group_id,
				pattern = { "*.lua", "*.go", "*.yaml", "*.yml" },
				command = "normal zR",
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
				},
				move = {
					set_jumps = true,
				},
			})

			-- Text object select keymaps
			local select = require("nvim-treesitter-textobjects.select")
			vim.keymap.set({ "x", "o" }, "aa", function()
				select.select_textobject("@parameter.outer", "textobjects")
			end, { desc = "outer parameter" })
			vim.keymap.set({ "x", "o" }, "ia", function()
				select.select_textobject("@parameter.inner", "textobjects")
			end, { desc = "inner parameter" })
			vim.keymap.set({ "x", "o" }, "af", function()
				select.select_textobject("@function.outer", "textobjects")
			end, { desc = "outer function" })
			vim.keymap.set({ "x", "o" }, "if", function()
				select.select_textobject("@function.inner", "textobjects")
			end, { desc = "inner function" })
			vim.keymap.set({ "x", "o" }, "ac", function()
				select.select_textobject("@class.outer", "textobjects")
			end, { desc = "outer class" })
			vim.keymap.set({ "x", "o" }, "ic", function()
				select.select_textobject("@class.inner", "textobjects")
			end, { desc = "inner class" })

			-- Move keymaps
			local move = require("nvim-treesitter-textobjects.move")
			vim.keymap.set({ "n", "x", "o" }, "]]", function()
				move.goto_next_start("@function.outer", "textobjects")
			end, { desc = "next function start" })
			vim.keymap.set({ "n", "x", "o" }, "]a", function()
				move.goto_next_start("@parameter.inner", "textobjects")
			end, { desc = "next parameter" })
			vim.keymap.set({ "n", "x", "o" }, "][", function()
				move.goto_next_end("@function.outer", "textobjects")
			end, { desc = "next function end" })
			vim.keymap.set({ "n", "x", "o" }, "[[", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end, { desc = "prev function start" })
			vim.keymap.set({ "n", "x", "o" }, "[a", function()
				move.goto_previous_start("@parameter.inner", "textobjects")
			end, { desc = "prev parameter" })
			vim.keymap.set({ "n", "x", "o" }, "[]", function()
				move.goto_previous_end("@function.outer", "textobjects")
			end, { desc = "prev function end" })

			-- Swap keymaps
			local swap = require("nvim-treesitter-textobjects.swap")
			vim.keymap.set("n", "ss", function()
				swap.swap_next("@parameter.inner")
			end, { desc = "swap with next parameter" })
			vim.keymap.set("n", "sd", function()
				swap.swap_previous("@parameter.inner")
			end, { desc = "swap with prev parameter" })
		end,
	},
}
