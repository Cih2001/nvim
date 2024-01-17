vim.opt.background = "dark" -- set this to dark or light
-- local scheme = "catppuccin-mocha"
local scheme = "rose-pine-moon"
vim.cmd.colorscheme(scheme)

if scheme == "tokyonight-moon" then
	vim.cmd("hi CursorLineNr guifg=#e0af68")
elseif scheme == "onenord" then
	require("onenord").setup({
		borders = true, -- Split window borders
		fade_nc = false, -- Fade non-current windows, making them more distinguishable
		-- Style that is applied to various groups: see `highlight-args` for options
		styles = {
			comments = "NONE",
			strings = "NONE",
			keywords = "NONE",
			functions = "NONE",
			variables = "NONE",
			diagnostics = "underline",
		},
		disable = {
			background = true, -- Disable setting the background color
			cursorline = false, -- Disable the cursorline
			eob_lines = true, -- Hide the end-of-buffer lines
		},
		-- Inverse highlight for different groups
		inverse = {
			match_paren = false,
		},
		custom_highlights = {}, -- Overwrite default highlight groups
		custom_colors = {}, -- Overwrite default colors
	})

	vim.cmd("hi Normal guibg=#1a1a1a")
	vim.cmd("hi NeoTreeNormal guibg=#1a1a1a")
	vim.cmd("hi NeoTreeNormalNc guibg=#1a1a1a")
	vim.cmd("hi CursorLine guibg=#272727")
elseif scheme == "nordic" then
	vim.cmd("hi Comment guifg=#6c7a96")
	vim.cmd("hi LineNr guifg=#6c7a96")
	vim.cmd("hi CursorLineNr guifg=#c8d0e0")
else
	vim.cmd("hi LineNr guifg=#6b7291")
	vim.cmd("hi CursorColumn guibg=#aa0000")
	vim.cmd("hi VertSplit gui=NONE guibg=LineNr guifg=#aaaaaa")
	vim.cmd("hi clear SignColumn")
	vim.cmd("hi GitsignsCurrentLineBlame guifg=#606060")
	vim.cmd("hi IblIndent guifg=#404040")
end
