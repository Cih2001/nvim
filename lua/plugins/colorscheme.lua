return {
	{
		"Mofiqul/vscode.nvim",
	},
	{
		"bluz71/vim-moonfly-colors",
		name = "moonfly",
		lazy = false,
		priority = 1000,
		init = function()
			-- Lua initialization file
			local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "moonfly",
				callback = function()
					vim.api.nvim_set_hl(0, "FzfLuaBorder", { fg = "#6e6e6e" })
				end,
				group = custom_highlight,
			})
			vim.cmd.colorscheme("moonfly")
			vim.cmd("highlight VertSplit guifg=#444444 guibg=#080808")
		end,
	},
	{
		"datsfilipe/vesper.nvim",
		init = function()
			require("vesper").setup({
				transparent = false, -- Boolean: Sets the background to transparent
				italics = {
					comments = false, -- Boolean: Italicizes comments
					keywords = false, -- Boolean: Italicizes keywords
					functions = false, -- Boolean: Italicizes functions
					strings = false, -- Boolean: Italicizes strings
					variables = false, -- Boolean: Italicizes variables
				},
				overrides = {}, -- A dictionary of group names, can be a function returning a dictionary or a table.
				palette_overrides = {},
			})
			-- vim.cmd.colorscheme("vesper")
		end,
	},
}
