-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- nvimtree
return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	config = function(_, opts)
		require("nvim-tree").setup(opts)
	end,
	keys = {
		{ "<c-z>", "<cmd>NvimTreeToggle<cr>" },
	},
	lazy = true,
	opts = {
		sort = {
			sorter = "case_sensitive",
		},
		view = {
			width = 30,
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
	},
}
