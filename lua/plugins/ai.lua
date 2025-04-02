return {
	"robitx/gp.nvim",
	config = function()
		require("gp").setup({
			agents = {
				{
					provider = "openai",
					name = "ChatGPT-o1",
					chat = true,
					command = false,
					model = { model = "o1" },
					system_prompt = require("gp.defaults").chat_system_prompt,
				},
			},
		})
	end,
	lazy = true,
	keys = {
		{ "<leader>c", "<cmd>GpChatToggle<cr>", desc = "Open chat gpt" },
	},
}
