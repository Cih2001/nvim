-- nvimtree
return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	config = function(_, opts)
		require("nvim-tree").setup(opts)

		local saved_width = 30
		vim.keymap.set("n", "<c-z>", function()
			local api = require("nvim-tree.api")

			-- If tree is open, save its current width before closing
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				if vim.api.nvim_buf_get_name(buf):match("NvimTree_") then
					saved_width = vim.api.nvim_win_get_width(win)
					break
				end
			end

			api.tree.toggle()

			vim.schedule(function()
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					if vim.api.nvim_buf_get_name(buf):match("NvimTree_") then
						vim.api.nvim_win_set_width(win, saved_width)
						break
					end
				end
			end)
		end, { silent = true, noremap = true })
	end,
	keys = {
		{ "<c-z>" },
	},
	lazy = true,
	opts = {
		sort = {
			sorter = "case_sensitive",
		},
		view = {
			width = 30,
			preserve_window_proportions = true,
		},
		renderer = {
			group_empty = true,
		},
		filters = {
			dotfiles = true,
		},
		update_focused_file = {
			enable = true,
		},
		diagnostics = {
			enable = true,
		},
		modified = {
			enable = true,
		},
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")

			-- Default mappings
			api.config.mappings.default_on_attach(bufnr)

			-- Custom enter key mapping that preserves window width
			vim.keymap.set("n", "<CR>", function()
				-- Get the nvim-tree window
				local tree_winid = vim.api.nvim_get_current_win()
				local current_width = vim.api.nvim_win_get_width(tree_winid)

				-- Open the file
				api.node.open.edit()

				-- Schedule the width restoration to happen after the file opens
				vim.schedule(function()
					-- Find the nvim-tree window again (in case focus moved)
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)
						local bufname = vim.api.nvim_buf_get_name(buf)
						if bufname:match("NvimTree_") then
							vim.api.nvim_win_set_width(win, current_width)
							break
						end
					end
				end)
			end, { buffer = bufnr, noremap = true, silent = true, desc = "Open file and preserve width" })
		end,
	},
}
