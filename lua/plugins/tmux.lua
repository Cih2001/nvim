return {
	"christoomey/vim-tmux-navigator",
	keys = {
		{ "<C-j>", "<cmd>TmuxNavigateDown<cr>" },
		{ "<C-k>", "<cmd>TmuxNavigateUp<cr>" },
		{ "<C-h>", "<cmd>TmuxNavigateLeft<cr>" },
		{ "<C-l>", "<cmd>TmuxNavigateRight<cr>" },
	},
	init = function()
		-- Keep plugin's mappings minimal; add terminal support
		vim.g.tmux_navigator_no_mappings = 1
	end,
}
