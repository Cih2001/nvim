local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.keymap.set("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	vim.keymap.set("v", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	vim.keymap.set("x", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	vim.keymap.set("n", "[c", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
	vim.keymap.set("n", "]c", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
end

local function on_attach(client, bufnr)
	lsp_keymaps(bufnr)
	local ill = require("illuminate")
	ill.on_attach(client)
end

return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local config = {
				-- disable virtual text
				virtual_text = false,
				-- show signs
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.INFO] = "",
						[vim.diagnostic.severity.HINT] = "",
					},
				},
				update_in_insert = true,
				underline = true,
				severity_sort = true,
				float = {
					focusable = false,
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			}

			vim.diagnostic.config(config)

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"RRethy/vim-illuminate",
		},
		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local lspconfig = require("lspconfig")

			-- enable mason
			mason.setup()

			local servers = {
				"gopls",
				"lua_ls",
				"terraformls",
				"buf_ls",
			}

			mason_lspconfig.setup({
				-- list of servers for mason to install
				ensure_installed = servers,
				-- auto-install configured servers (with lspconfig)
				automatic_installation = true, -- not the same as ensure_installed
			})

			for _, server in pairs(servers) do
				local opts = { on_attach = on_attach }
				local has_custom_opts, server_custom_opts = pcall(require, "lsp_configs." .. server)
				if has_custom_opts then
					opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
				end
				lspconfig[server].setup(opts)
			end
		end,
	},
	{
		"smjonas/inc-rename.nvim",
		config = function()
			require("inc_rename").setup()
		end,
		keys = { { "<leader>rn", ":IncRename " } },
	},
	{
		"RRethy/vim-illuminate",
		keys = {
			-- Illuminate --
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
			{
				"<C-]>",
				function()
					require("illuminate").next_reference({ wrap = true })
					vim.cmd(":normal! zz")
				end,
			},
			{
				"<A-j>",
				function()
					require("illuminate").next_reference({ reverse = true, wrap = true })
					vim.cmd(":normal! zz")
				end,
			},
		},
	},
}
