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

-- open man page in vertical split for C files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "c",
	callback = function()
		vim.keymap.set("n", "<S-k>", function()
			local word = vim.fn.expand("<cword>")
			vim.cmd("vertical Man " .. word)
		end, { buffer = true, desc = "Open man page in vertical split" })
	end,
})
