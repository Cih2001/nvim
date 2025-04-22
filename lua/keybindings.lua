-- This file contains the keybindings for nvim vanilla features.
-- For the plugin keybindings, take a look at the respected file
-- where the plugin is defined. For example, to find fzf
-- keybindings, take a look at fzf.lua.
local opts = { silent = true, noremap = true }

-- Resize with arrows
vim.keymap.set("n", "<Up>", "<cmd>resize -2<CR>", opts)
vim.keymap.set("n", "<Down>", "<cmd>resize +2<CR>", opts)
vim.keymap.set("n", "<Left>", "<cmd>vertical resize -2<CR>", opts)
vim.keymap.set("n", "<Right>", "<cmd>vertical resize +2<CR>", opts)
vim.keymap.set("n", "+", "<C-w>|", opts)
vim.keymap.set("n", "=", "<C-w>=", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Move text up and down
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", opts)

-- Down is really the next line
-- Enables moving down in wraped texts
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- keep it on the center
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- custom functionalities
vim.keymap.set("n", "<leader>t", '<cmd>lua require("custom").custom()<cr>', opts)

-- quick fix
--
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf", -- only apply to quick fix
	callback = function()
		-- delete items from the quick fix window.
		vim.keymap.set("n", "dd", function()
			local curqfidx = vim.fn.line(".") - 1 -- Get the current line index in quickfix list
			local qfall = vim.fn.getqflist() -- Get all items in quickfix list
			table.remove(qfall, curqfidx + 1) -- Remove the current quickfix item, adjust index for Lua (base-1 index)
			vim.fn.setqflist(qfall, "r") -- Replace the quickfix list with the modified list
			vim.cmd(tostring(curqfidx + 1) .. "cfirst")
			vim.cmd("copen")
		end, { buffer = true, noremap = true, silent = true })
	end,
})

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", opts)
