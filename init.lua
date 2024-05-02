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
require("user.options")
-- text editing
require("user.treesitter")
require("user.autopairs")
-- ui
require("user.colorscheme")
require("user.lualine")
require("user.harpoon")
require("user.gitsigns")
require("user.indentline")
-- lsp
require("user.cmp")
require("user.lsp")
require("user.luasnip")
require("user.null-ls")
-- debugger
require("user.dap")
-- fuzzy
require("user.telescope")
require("user.fzf")
-- db
-- require("user.db")
-- we are using Dbee now
-- productivity
require("user.neotree")
require("user.octo")
-- require("user.chatgpt")
require("user.custom")
--
require("user.keybindings")
