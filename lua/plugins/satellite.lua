return {
	"lewis6991/satellite.nvim",
	config = function(_, opts)
		require("satellite").setup(opts)
	end,
	opts = {
		handlers = {
			gitsigns = {
				enable = false,
			},
		},
	},
}
