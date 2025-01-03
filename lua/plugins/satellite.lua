return {
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
}
