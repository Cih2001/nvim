------------------------------------------------
-- some useful key bindings
------------------------------------------------
local opts = { silent = true, noremap = true }

-- Resize with arrows
vim.keymap.set("n", "+", "<C-w>|", opts)
vim.keymap.set("n", "=", "<C-w>=", opts)

-- Switch windows
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", opts)
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", opts)
vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", opts)
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Move text up and down
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", opts)

-- Harpoon
vim.keymap.set("n", "<S-l>", '<cmd>lua require("user.harpoon").next()<cr>')
vim.keymap.set("n", "<S-h>", '<cmd>lua require("user.harpoon").prev()<cr>')
vim.keymap.set("n", "m", '<cmd>lua require("user.harpoon").add()<cr>')
vim.keymap.set("n", "<space>v", '<cmd>lua require("user.harpoon").toggle()<cr>')
vim.keymap.set("n", "<S-q>", '<cmd>lua require("user.harpoon").remove()<cr>')

-- NvimTree
vim.keymap.set("n", "<c-z>", "<cmd>NvimTreeToggle<cr>", opts)

-- Fzf --
vim.keymap.set("n", "<space>b", "<cmd>FzfLua buffers<cr>", opts)
vim.keymap.set("n", "<space>f", "<cmd>FzfLua files<cr>", opts)
vim.keymap.set("n", "<space>g", "<cmd>FzfLua live_grep<cr>", opts)
vim.keymap.set("n", "<space>o", "<cmd>FzfLua lsp_document_symbols<cr>", opts)
vim.keymap.set("n", "<space>s", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", opts)
vim.keymap.set("n", "<space>j", "<cmd>FzfLua jumplist<cr>", opts)
vim.keymap.set("n", "<space>c", "<cmd>FzfLua grep_curbuf<cr>", opts)
vim.keymap.set("n", "<space>r", "<cmd>FzfLua registers<cr>", opts)
vim.keymap.set("n", "<space>p", "<cmd>Octo pr list<cr>", opts)
vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references<cr>", opts)
vim.keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", opts)
vim.keymap.set("n", "gy", "<cmd>FzfLua lsp_typedefs<cr>", opts)
vim.keymap.set("n", "<space>a", "<cmd>FzfLua diagnostics_workspace<CR>", opts)
vim.keymap.set("n", "<space>h", "<cmd>FzfLua help_tags<CR>", opts)

-- lsp rename --
vim.keymap.set("n", "<leader>rn", function()
	return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })

-- Illuminate --
vim.keymap.set("n", "<C-]>", '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', opts)
-- c-[ has the same char code as esc. It can be remapped in neovim, if your terminal
-- supports extended keys and  both keys are mapped. :help <Tab>.
--
-- Kitty supports extended keys but it has its own protocol that tmux doesn't support yet:
-- https://github.com/tmux/tmux/issues/4196
-- Therefore we need a workaround: In your kitty config (.config/kitty/kitty.conf) remap
-- C-[ to A-j by the following command
--
-- map ctrl+[ send_key alt+j
--
-- and create a map for alt-j:
vim.keymap.set("n", "<A-j>", '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', opts)

-- Debug --
vim.keymap.set("n", "<F1>", '<cmd>lua require"dapui".toggle()<cr>', opts)
vim.keymap.set("n", "<F2>", '<cmd>lua require"dap".toggle_breakpoint()<cr>', opts)
vim.keymap.set("n", "<F3>", '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint Condition: "))<cr>', opts)
vim.keymap.set("n", "<F4>", '<cmd>lua require"dap".run_to_cursor()<cr>', opts)
vim.keymap.set("n", "<F5>", '<cmd>lua require"dap".continue()<cr>', opts)
vim.keymap.set("n", "<F6>", '<cmd>lua require"dap".step_over()<cr>', opts)
vim.keymap.set("n", "<F7>", '<cmd>lua require"dap".step_into()<cr>', opts)
vim.keymap.set("n", "<F8>", '<cmd>lua require"dap".step_out()<cr>', opts)
vim.keymap.set("n", "<C-q>", '<cmd>lua require"dapui".eval(nil, { enter = true })<cr>', opts)
vim.keymap.set("n", "<leader>dp", '<cmd>lua require("user.dap").debug_python()<cr>', opts)

-- Gitsigns --
vim.keymap.set("n", "]g", "<cmd>Gitsigns next_hunk<cr>", opts)
vim.keymap.set("n", "[g", "<cmd>Gitsigns prev_hunk<cr>", opts)
vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<cr>", opts)
vim.keymap.set("n", "<leader>gg", "<cmd>Gitsigns toggle_current_line_blame<cr>", opts)
vim.keymap.set("n", "<leader>gs", "<cmd>FzfLua git_status<cr>", opts)
vim.keymap.set("n", "<leader>gb", "<cmd>FzfLua git_branches<cr>", opts)
vim.keymap.set("n", "<leader>gc", "<cmd>FzfLua git_commits<cr>", opts)

-- treesitter key bindings
-- take a look at treesitter.lua

-- DB
vim.cmd("autocmd FileType sql nmap <buffer> <Leader>e <Plug>(DBUI_EditBindParameters)")
vim.cmd("autocmd FileType sql nmap <buffer> <Leader>s <Plug>(DBUI_ExecuteQuery)")

-- custom functionalities
vim.keymap.set("n", "<leader>t", '<cmd>lua require("user.custom").custom()<cr>', opts)
