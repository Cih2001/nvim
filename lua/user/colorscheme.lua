vim.cmd [[
try
  colorscheme darkplus
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]

vim.cmd("hi CursorColumn guibg=#aa0000")
vim.cmd("hi clear SignColumn")
vim.cmd("hi GitsignsCurrentLineBlame guifg=#40aa28")
