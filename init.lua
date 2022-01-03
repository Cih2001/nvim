local opts = { noremap = true, silent = true }
local term_opts = { silent = true }
local keymap = vim.api.nvim_set_keymap

function nmap(shortcut, command, settings)
  keymap("n", shortcut, command, settings)
end

function imap(shortcut, command, settings)
  keymap("i", shortcut, command, settings)
end

function xmap(shortcut, command, settings)
  keymap("x", shortcut, command, settings)
end



vim.cmd("command! Wq :wq")
vim.cmd("command! W :w")

-- if hidden is not set, TextEdit might fail.
vim.o.hidden = true
-- Better display for messages
vim.o.cmdheight = 2
--  Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
--  delays and poor user experience.
vim.o.updatetime = 300
-- don't give |ins-completion-menu| messages.
vim.o.shortmess = vim.o.shortmess.."c"
-- always show signcolumns
vim.o.signcolumn = "yes"
vim.cmd("highlight clear SignColumn")

-- remap tab to escape key
vim.cmd("au VimEnter * silent! !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'")
vim.cmd("au VimLeave * silent! !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'")

------------------------------------------------
-- some useful key bindings
------------------------------------------------
--
-- Resize with arrows
nmap("<C-S-Up>", ":resize -2<CR>", opts)
nmap("<C-S-Down>", ":resize +2<CR>", opts)
nmap("<C-S-Left>", ":vertical resize -2<CR>", opts)
nmap("<C-S-Right>", ":vertical resize +2<CR>", opts)

-- Switch windows
nmap("<C-j>", "<C-w>j", opts)
nmap("<C-k>", "<C-w>k", opts)
nmap("<C-l>", "<C-w>l", opts)
nmap("<C-h>", "<C-w>h", opts)

-- Navigate buffers
nmap("<S-l>", ":bnext<CR>", opts)
nmap("<S-h>", ":bprevious<CR>", opts)
nmap("<S-q>", ":bdelete<CR>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

vim.cmd([[
" Install plugins
call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' } " for go development.
Plug 'neoclide/coc.nvim', {'branch': 'release'} " awesome coc-nvim.
Plug 'honza/vim-snippets'
Plug 'haya14busa/incsearch.vim' " I mainly use it for highlight feature.
Plug 'alvan/vim-closetag' " for painless html.
Plug 'mg979/vim-visual-multi', {'branch': 'master'} " for having multiple cursors.
Plug 'preservim/nerdtree'
Plug 'rhysd/vim-clang-format', {'branch': 'master'} " for using clang-format

Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons' " Recommended (for coloured icons)
Plug 'akinsho/bufferline.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'lunarvim/darkplus.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
call plug#end()
]])

----------------------------------------------
-- incsearch settings
----------------------------------------------
nmap("/", "<Plug>(incsearch-forward)", {})
nmap("?", "<Plug>(incsearch-backward)", {})
nmap("g/", "<Plug>(incsearch-stay)", {})

----------------------------------------------
-- coc-nvim settings
----------------------------------------------
-- Use tab for trigger completion with characters ahead and navigate.
-- Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
vim.cmd([[
function! s:check_back_space() abort
let col = col('.') - 1
return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
]])

-- Use K to show documentation in preview window.
vim.cmd([[
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>
]])

-- Use <c-space> to trigger completion.
-- vim.cmd("inoremap <silent><expr> <c-space> coc#refresh()")
imap("<c-space>", "coc#refresh()", {silent = true, expr = true})

-- Use `[c` and `]c` to navigate diagnostics
nmap("[c", "<Plug>(coc-diagnostic-prev)", {silent = true})
nmap("]c", "<Plug>(coc-diagnostic-next)", {silent = true})

-- Remap keys for gotos
nmap("gd", "<Plug>(coc-definition)", {silent = true})
nmap("gy", "<Plug>(coc-type-definition)", {silent = true})
nmap("gi", "<Plug>(coc-implementation)", {silent = true})
nmap("gr", "<Plug>(coc-references)", {silent = true})

-- Highlight the symbol and its references when holding the cursor.
vim.cmd("autocmd CursorHold * silent call CocActionAsync('highlight')")

-- Remap for rename current word
nmap("<leader>rn", "<Plug>(coc-rename)", {})

-- Formatting selected code.
xmap("<leader>f", "<Plug>(coc-format-selected)", {})
nmap("<leader>f", "<Plug>(coc-format-selected)", {})


-- Applying codeAction to the selected region.
-- Example: `<leader>aap` for current paragraph
xmap("<leader>a", "<Plug>(coc-codeaction-selected)", {})
nmap("<leader>a", "<Plug>(coc-codeaction-selected)", {})

-- Remap keys for applying codeAction to the current buffer.
nmap("<leader>ac", "<Plug>(coc-codeaction)", {})

-- Apply AutoFix to problem on the current line.
nmap("<leader>qf", "<Plug>(coc-fix-current)", {})

-- Add `:Format` command to format current buffer.
vim.cmd("command! -nargs=0 Format :call CocAction('format')")

-- Add `:Fold` command to fold current buffer.
vim.cmd("command! -nargs=? Fold :call     CocAction('fold', <f-args>)")

-- Show all diagnostics
nmap("<space>a", ":<C-u>CocList diagnostics<cr>", {silent = true, noremap = true})
-- Manage extensions
nmap("<space>e", ":<C-u>CocList extensions<cr>", {silent = true, noremap = true})
-- Show commands
nmap("<space>c", ":<C-u>CocList commands<cr>", {silent = true, noremap = true})
-- Find symbol of current document
nmap("<space>o", ":<C-u>CocList outline<cr>", {silent = true, noremap = true})
-- Search workspace symbols
nmap("<space>s", ":<C-u>CocList -I symbols<cr>", {silent = true, noremap = true})
-- Do default action for next item.
nmap("<space>j", ":<C-u>CocNext<CR>", {silent = true, noremap = true})
-- Do default action for previous item.
nmap("<space>k", ":<C-u>CocPrev<CR>", {silent = true, noremap = true})
-- Resume latest coc list
nmap("<space>p", ":<C-u>CocListResume<CR>", {silent = true, noremap = true})
-- use enter for autocomplete
vim.cmd([[inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"]])

-- disable vim-go :GoDef short cut (gd)
-- this is handled by LanguageClient [LC]
vim.g.go_def_mapping_enabled = 0

-- use gofumpt instead of fmt.
vim.g.go_fmt_command = "gopls"
vim.g.go_gopls_gofumpt = 1

----------------------------------------------
-- closing tag settings
----------------------------------------------
vim.g.closetag_filetypes = 'html,vue'

----------------------------------------------
-- nerd tree settings
----------------------------------------------
nmap("<c-z>" ,":NERDTreeToggle<cr>", {})
vim.g.NERDTreeShowHidden = 1

----------------------------------------------
-- go debug layout
----------------------------------------------
vim.g.go_debug_windows = {vars='rightbelow 60vnew', stack='rightbelow 10new'}

require "user.options"
require "user.bufferline"
require "user.lualine"
require "user.colorscheme"
require "user.gitsigns"
require "user.indentline"
