return {
	{
		"Cih2001/pikchr.nvim",
		lazy = true,
		cmd = "Pikchr",
		config = function()
			require("pikchr").setup({
				server_port = 1234,
			})
		end,
	},
}
