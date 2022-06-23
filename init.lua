require "user.plugins"
require "user.options"
require "user.keybindings"
require "user.treesitter"
require "user.bufferline"
require "user.nerdtree"
require "user.lualine"
require "user.colorscheme"
require "user.gitsigns"
require "user.indentline"
require "user.cmp"
require "user.lsp"
require "user.telescope"
require "user.luasnip"
require "user.dap"

local function test()
  local ts_utils = require 'nvim-treesitter.ts_utils'
  local tsnode = ts_utils.get_node_at_cursor()
  print(tsnode)
end

vim.keymap.set("n", "<leader>t", "", { callback = test })
