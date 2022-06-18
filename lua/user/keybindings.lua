------------------------------------------------
-- some useful key bindings
------------------------------------------------
opts = {silent = true}

-- Resize with arrows
vim.keymap.set("n", "<C-S-Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-S-Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-S-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-S-Right>", ":vertical resize +2<CR>", opts)

-- Switch windows
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<S-q>", ":bdelete<CR>", opts)

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
vim.keymap.set("n", "<c-z>" ,":NERDTreeToggle<cr>", {})

