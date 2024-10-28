local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("user.plugins")
-- text editing
require("user.treesitter")
require("user.autopairs")
-- ui
require("user.options")
require("user.lualine")
require("user.harpoon")
require("user.gitsigns")
require("user.indentline")
-- lsp
require("user.cmp")
require("user.lsp")
require("user.null-ls")
-- debugger
require("user.dap")
-- fuzzy
require("user.fzf")
-- db
require("user.db")
-- productivity
require("user.neotree") -- consider switching to oil
require("user.octo")
require("user.custom")
-- keybindings
require("user.keybindings")
