return {
	"Mofiqul/vscode.nvim",
	config = function()
		local scheme = "vscode"
		vim.cmd.colorscheme(scheme)

		if scheme == "vscode" then
			-- make the cursor line in fzf lua a bit more visible
			vim.cmd.highlight({ "FzfLuaCursorLine", "guibg=#333333" })
		end
	end,
}
