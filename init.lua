require "user.plugins"
require "user.options"
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
require "user.octo"
require "user.folder"
require "user.keybindings"

local function custom()
  vim.ui.select({"test","browse pr-env"}, { prompt = "select an action" },
    function (choice)
      if choice == "browse pr-env" then
        vim.fn.jobstart("gh pr view --json number --jq .number", {
          stdout_buffered = true,
          on_stdout = function (_, output)
            local link = string.format("https://pr-%s.dev.esgbook.arabesque.com/", output[1])
            vim.fn.jobstart({"open", link})
          end
        })
      elseif choice == "test" then
        require("user.gotest").run_current_test()
      end
    end
  )
end

vim.keymap.set("n", "<leader>t", "", { callback = custom })
