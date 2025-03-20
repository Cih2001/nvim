return {
	{ "mg979/vim-visual-multi" },
	{
		"sindrets/diffview.nvim",
		lazy = true,
		cmd = { "DiffviewOpen" },
	},
	{
		"eandrju/cellular-automaton.nvim",
		lazy = true,
		cmd = "CellularAutomaton",
		keys = {
			{ "<leader>r", "<cmd>CellularAutomaton make_it_rain<cr>" },
		},
	},
}
