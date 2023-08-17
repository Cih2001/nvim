------------------------------------------------
-- some useful key bindings
------------------------------------------------
local opts = { silent = true, noremap = true }

-- Resize with arrows
vim.keymap.set("n", "<C-S-Up>", "<cmd>resize -2<CR>", opts)
vim.keymap.set("n", "<C-S-Down>", "<cmd>resize +2<CR>", opts)
vim.keymap.set("n", "<C-S-Left>", "<cmd>vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-S-Right>", "<cmd>vertical resize +2<CR>", opts)
vim.keymap.set("n", "+", "<C-w>|", opts)
vim.keymap.set("n", "=", "<C-w>=", opts)

-- Switch windows
vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<cr>", opts)
vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<cr>", opts)
vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<cr>", opts)
vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<cr>", opts)

-- Navigate buffers - harpoon
vim.keymap.set("n", "<S-l>", ':lua require("harpoon.ui").nav_next()<CR>', { silent = true })
vim.keymap.set("n", "<S-h>", ':lua require("harpoon.ui").nav_prev()<CR>', { silent = true })
vim.keymap.set("n", "m", ':lua require("harpoon.mark").add_file()<CR>', opts)
vim.keymap.set("n", "<space>v", ':lua require("harpoon.ui").toggle_quick_menu()<CR>', opts)
vim.keymap.set("n", "<S-q>", ':lua require("harpoon.mark").rm_file()<CR>', opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Visual Block --
-- Move text up and down
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", opts)
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- neo-tree --
local is_neotree_open = function()
	for _, source in ipairs(require("neo-tree").config.sources) do
		-- Get each sources state
		local state = require("neo-tree.sources.manager").get_state(source)
		-- Check if the source has a state, if the state has a buffer and if the buffer is our current buffer
		if state and state.bufnr then
			return true
		end
	end

	return false
end
vim.keymap.set("n", "<c-z>", function()
	if is_neotree_open() then
		vim.cmd("Neotree close left")
	else
		vim.cmd("Neotree focus filesystem left")
	end
end, opts)

vim.keymap.set("n", "<c-x>", function()
	if is_neotree_open() then
		vim.cmd("Neotree close left")
	else
		vim.cmd("Neotree focus document_symbols left")
	end
end, opts)

-- Telescope --
vim.keymap.set("n", "<space>b", "<cmd>FzfLua buffers<cr>", opts)
vim.keymap.set("n", "<space>f", "<cmd>FzfLua files<cr>", opts)
vim.keymap.set("n", "<space>g", "<cmd>FzfLua live_grep<cr>", opts)
vim.keymap.set("n", "<space>o", "<cmd>FzfLua lsp_document_symbols<cr>", opts)
vim.keymap.set("n", "<space>s", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", opts)
vim.keymap.set("n", "<space>j", "<cmd>FzfLua jumplist<cr>", opts)
vim.keymap.set("n", "<space>c", "<cmd>FzfLua grep_curbuf<cr>", opts)
vim.keymap.set("n", "<space>p", "<cmd>Octo pr list<cr>", opts)
vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references<cr>", opts)
vim.keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", opts)
vim.keymap.set("n", "gy", "<cmd>FzfLua lsp_typedefs<cr>", opts)
vim.keymap.set("n", "<space>a", "<cmd>FzfLua diagnostics_workspace<CR>", opts)
vim.keymap.set("n", "<space>h", "<cmd>FzfLua help_tags<CR>", opts)

-- Illuminate --
vim.keymap.set("n", "<C-]>", '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', opts)
vim.keymap.set("n", "<C-[>", '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', opts)

-- Debug --
vim.keymap.set("n", "<F1>", '<cmd>lua require"dapui".toggle()<cr>', opts)
vim.keymap.set("n", "<F2>", '<cmd>lua require"dap".toggle_breakpoint()<cr>', opts)
vim.keymap.set("n", "<F3>", '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint Condition: "))<cr>', opts)
vim.keymap.set("n", "<F5>", '<cmd>lua require"dap".continue()<cr>', opts)
vim.keymap.set("n", "<F6>", '<cmd>lua require"dap".step_over()<cr>', opts)
vim.keymap.set("n", "<F7>", '<cmd>lua require"dap".step_into()<cr>', opts)
vim.keymap.set("n", "<F8>", '<cmd>lua require"dap".step_out()<cr>', opts)
vim.keymap.set("n", "<leader>dt", '<cmd>lua require"dap-go".debug_test()<cr>', opts)

-- octo fix --
-- vim.keymap.set("n", "<C-M>", '<cmd>lua require("octo.mappings").comment_review()<cr>', opts)

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
vim.keymap.set("n", "<c-q>", "<cmd>Gitsigns toggle_current_line_blame<cr>", opts)
