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
-- to go back to normal mode with escape in terminal
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

vim.keymap.set("n", "<leader>w", function()
	vim.o.wrap = not vim.o.wrap
end, opts)

-- User commands
vim.api.nvim_create_user_command("W", ":noautocmd w", {})
vim.api.nvim_create_user_command("Wq", ":wq", {})

local function relative_norm(count, direction, cmd)
	local current_pos = vim.api.nvim_win_get_cursor(0)
	local c = string.format("keepjumps normal! %d%s%s", count, direction, cmd)
	vim.cmd(c)
	vim.api.nvim_win_set_cursor(0, current_pos)
end

vim.api.nvim_create_user_command("J", function(arg)
	---@diagnostic disable-next-line: undefined-field
	relative_norm(arg.count, "j", arg.args)
end, { range = true, nargs = "+", complete = nil })

vim.api.nvim_create_user_command("K", function(arg)
	---@diagnostic disable-next-line: undefined-field
	relative_norm(arg.count, "k", arg.args)
end, { range = true, nargs = "+", complete = nil })
