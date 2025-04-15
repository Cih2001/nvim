-- spellcheck in md
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	command = "setlocal spell wrap",
})

-- highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 300, priority = 1000 })
	end,
})
