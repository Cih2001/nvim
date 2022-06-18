require "user.plugins"
require "user.options"
require "user.keybindings"
require "user.bufferline"
require "user.lualine"
require "user.colorscheme"
require "user.gitsigns"
require "user.indentline"

-- use gofumpt instead of fmt.
vim.g.go_fmt_command = "gopls"
vim.g.go_gopls_gofumpt = 1

-- golang linters
vim.g.go_metalinter_command = "golangci-lint"

vim.g.NERDTreeShowHidden = 1
