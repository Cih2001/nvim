------------------------------------------------
-- some useful key bindings
------------------------------------------------
local opts = { silent = true, noremap = true }

-- Resize with arrows
vim.keymap.set("n", "<C-S-Up>", "<cmd>resize -2<CR>", opts)
vim.keymap.set("n", "<C-S-Down>", "<cmd>resize +2<CR>", opts)
vim.keymap.set("n", "<C-S-Left>", "<cmd>vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-S-Right>", "<cmd>vertical resize +2<CR>", opts)
vim.keymap.set("n", "\\", "<C-w>|", opts)
vim.keymap.set("n", "=", "<C-w>=", opts)

-- Switch windows
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<S-q>", ":bn|bd#<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Visual Block --
-- Move text up and down
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", opts)
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Nerd Tree --
vim.keymap.set("n", "<c-z>", function()
	local open = vim.api.nvim_eval("g:NERDTree.IsOpen()")
	if open == 1 then
		vim.cmd("NERDTreeClose")
	elseif vim.api.nvim_eval("&modifiable && strlen(expand('%')) > 0 && !&diff") == 1 then
		vim.cmd("NERDTreeFind")
	else
		vim.cmd("NERDTree")
	end
end, opts)

-- Telescope --
vim.keymap.set("n", "<space>b", "<cmd>Telescope buffers<cr>", opts)
vim.keymap.set("n", "<space>f", "<cmd>Telescope find_files<cr>", opts)
vim.keymap.set("n", "<space>g", "<cmd>Telescope live_grep<cr>", opts)
vim.keymap.set("n", "<space>o", "<cmd>Telescope lsp_document_symbols<cr>", opts)
vim.keymap.set("n", "<space>s", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", opts)
vim.keymap.set("n", "<space>j", "<cmd>Telescope jumplist<cr>", opts)
vim.keymap.set("n", "<space>c", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts)
vim.keymap.set("n", "<space>p", "<cmd>Octo pr list<cr>", opts)
vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)
vim.keymap.set("n", "gy", "<cmd>Telescope lsp_type_definitions<cr>", opts)
vim.keymap.set("n", "<leader>i", [[<cmd>lua require'telescope'.extensions.goimpl.goimpl{}<CR>]], opts)
vim.keymap.set("n", "<space>a", "<cmd>Telescope diagnostics<CR>", opts)
vim.keymap.set("n", "<space>h", "<cmd>Telescope help_tags<CR>", opts)

-- Illuminate --
-- vim.keymap.set('n', '<C-[>', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', opts)
-- vim.keymap.set('n', '<C-]>', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', opts)

-- Debug --
vim.keymap.set("n", "<F1>", '<cmd>lua require"dapui".toggle()<cr>', opts)
vim.keymap.set("n", "<F2>", '<cmd>lua require"dap".toggle_breakpoint()<cr>', opts)
vim.keymap.set("n", "<F3>", '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint Condition: "))<cr>', opts)
vim.keymap.set("n", "<F5>", '<cmd>lua require"dap".continue()<cr>', opts)
vim.keymap.set("n", "<F6>", '<cmd>lua require"dap".step_over()<cr>', opts)
vim.keymap.set("n", "<F7>", '<cmd>lua require"dap".step_into()<cr>', opts)
vim.keymap.set("n", "<F8>", '<cmd>lua require"dap".step_out()<cr>', opts)
vim.keymap.set("n", "<leader>dt", '<cmd>lua require"dap-go".debug_test()<cr>', opts)

-- Symbol Outline--
vim.keymap.set("n", "<c-x>", "<cmd>SymbolsOutline<cr>", opts)

-- octo fix --
vim.keymap.set("n", "<c-s-m>", '<cmd>lua require("octo.mappings").comment_review()<cr>', opts)

-- leap --
vim.keymap.set({ "n", "x", "o" }, "f", "<Plug>(leap-forward-to)", opts)
vim.keymap.set({ "n", "x", "o" }, "F", "<Plug>(leap-backward-to)", opts)

-- treesitter key bindings
-- take a look at treesitter.lua

-- DB
vim.cmd("autocmd FileType sql nmap <buffer> <Leader>e <Plug>(DBUI_EditBindParameters)")
vim.cmd("autocmd FileType sql nmap <buffer> <Leader>s <Plug>(DBUI_ExecuteQuery)")

-- custom functionalities
vim.keymap.set("n", "<leader>t", '<cmd>lua require("user.custom").custom()<cr>', opts)

vim.keymap.set("n", "<c-q>", function()
	local keybinds = string.format("%s/.config/nvim/lua/user/textcortex.lua", os.getenv("HOME"))
	dofile(keybinds)
	-- print(vim.api.nvim_eval("expand('%')"))
end, opts)
