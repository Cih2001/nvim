return {
	"FabijanZulj/blame.nvim",
	lazy = true,
	config = function(_, opts)
		require("blame").setup(opts)
	end,
	keys = {
		{ "<leader>q", "<cmd>BlameToggle<cr>" },
	},
	opts = {
		blame_options = { "-CCC" },
		mappings = {
			commit_info = "i",
			stack_push = "<TAB>",
			stack_pop = "<BS>",
			show_commit = "<CR>",
			close = { "q" },
		},
	},
}
