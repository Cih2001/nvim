-- find more here: https://www.nerdfonts.com/cheat-sheet
local options = {
	autoindent = true,
	background = "dark", -- set this to dark or light
	backup = false, -- creates a backup file
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	cmdheight = 1, -- more space in the neovim command line for displaying messages
	completeopt = { "menuone", "noselect" }, -- mostly just for cmp
	concealcursor = "n",
	conceallevel = 0, -- so that `` is visible in markdown files
	cursorline = true, -- highlight the current line
	expandtab = false, -- convert tabs to spaces
	fileencoding = "utf-8", -- the encoding written to a file
	foldenable = false,
	foldexpr = "nvim_treesitter#foldexpr()",
	foldmethod = "expr",
	guifontwide = "DroidSansMono Nerd Font:h17", -- the font used in graphical neovim applications
	guifont = "*", -- the font used in graphical neovim applications
	hidden = true, -- if hidden is not set, TextEdit might fail.
	hlsearch = false, -- highlight all matches on previous search pattern
	ignorecase = true, -- ignore case in search patterns
	incsearch = true, -- highlight the match for the current search pattern
	laststatus = 2,
	mmp = 5000,
	mouse = "a", -- allow the mouse to be used in neovim
	number = true, -- set numbered lines
	numberwidth = 4, -- set number column width to 2 {default 4}
	path = "**",
	pumheight = 10, -- pop up menu height
	relativenumber = true, -- set relative numbered lines
	scrolloff = 8, -- is one of my fav
	shiftwidth = 2, -- the number of spaces inserted for each indentation
	showmode = false, -- we don't need to see things like -- INSERT -- anymore
	showtabline = 2, -- always show tabs
	sidescrolloff = 8,
	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
	smartcase = true, -- smart case
	smartindent = true, -- make indenting smarter again
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	swapfile = false, -- creates a swapfile
	tabstop = 2, -- insert 2 spaces for a tab
	termguicolors = true, -- set term gui colors (most terminals support this)
	timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
	undofile = true, -- enable persistent undo
	updatetime = 300, --  Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
	wildmenu = true,
	wrap = false, -- display lines as one long line
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	listchars = {
		tab = "→ ",
		eol = "↲",
		nbsp = "␣",
		lead = "␣",
		space = "␣",
		trail = "•",
		extends = "⟩",
		precedes = "⟨",
	},
}

-- vim.o.showcmd = true
--
-- don't give |ins-completion-menu| messages.
vim.o.shortmess = vim.o.shortmess .. "c"

for k, v in pairs(options) do
	vim.opt[k] = v
end
-- Disable providers we do not care a about
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Disable some in built plugins completely
local disabled_built_ins = {
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"gzip",
	"zip",
	"zipPlugin",
	"tar",
	"tarPlugin",
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	"logipat",
	"rrhelper",
	"spellfile_plugin",
	-- 'matchit',
	-- 'matchparen',
}
for _, plugin in pairs(disabled_built_ins) do
	vim.g["loaded_" .. plugin] = 1
end

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd("set iskeyword+=-")
vim.api.nvim_create_user_command("W", ":noautocmd w", {})
vim.api.nvim_create_user_command("Wq", ":wq", {})
