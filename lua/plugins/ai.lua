return {
	"robitx/gp.nvim",
	config = function()
		require("gp").setup()
	end,
	lazy = true,
	keys = {
		{ "<leader>c", "<cmd>GpChatToggle<cr>", desc = "Open chat gpt" },
	},
}
