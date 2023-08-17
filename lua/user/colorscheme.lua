vim.cmd([[
try
  colorscheme tokyonight-night
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]])

vim.cmd("hi CursorColumn guibg=#aa0000")
vim.cmd("hi CursorLine guibg=#303030")
vim.cmd("hi VertSplit gui=NONE guibg=LineNr guifg=#aaaaaa")
vim.cmd("hi clear SignColumn")
vim.cmd("hi GitsignsCurrentLineBlame guifg=#606060")
