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

-- delete items from the quickfix window with `dd`
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		vim.keymap.set("n", "dd", function()
			local curqfidx = vim.fn.line(".") - 1
			local qfall = vim.fn.getqflist()
			table.remove(qfall, curqfidx + 1)
			vim.fn.setqflist(qfall, "r")
			vim.cmd(tostring(curqfidx + 1) .. "cfirst")
			vim.cmd("copen")
		end, { buffer = true, noremap = true, silent = true })
	end,
})
