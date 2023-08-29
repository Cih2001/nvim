local set_colorscheme = function(name)
	local cmd = string.format(
		[[
try
    colorscheme %s
catch /^Vim\\%%((\a\+)\)\=:E185/
    colorscheme default
    set background=dark
endtry
]],
		name
	)
	vim.cmd(cmd)
end

local scheme = "catppuccin-mocha"
set_colorscheme(scheme)

if scheme == "tokyonight-moon" then
	vim.cmd("hi CursorLineNr guifg=#e0af68")
end

vim.cmd("hi LineNr guifg=#6b7291")
vim.cmd("hi CursorColumn guibg=#aa0000")
vim.cmd("hi CursorLine guibg=#303030")
vim.cmd("hi VertSplit gui=NONE guibg=LineNr guifg=#aaaaaa")
vim.cmd("hi clear SignColumn")
vim.cmd("hi GitsignsCurrentLineBlame guifg=#606060")
