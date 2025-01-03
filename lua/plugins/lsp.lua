return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("lsp.diagnostics")
		end,
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local lspconfig = require("lspconfig")
			local handlers = require("lsp.handlers")

			-- enable mason
			mason.setup()

			local servers = {
				"gopls",
				"lua_ls",
				"terraformls",
				"zls",
			}

			mason_lspconfig.setup({
				-- list of servers for mason to install
				ensure_installed = servers,
				-- auto-install configured servers (with lspconfig)
				automatic_installation = true, -- not the same as ensure_installed
			})

			for _, server in pairs(servers) do
				local opts = {
					on_attach = handlers.on_attach,
					capabilities = handlers.capabilities,
				}
				local has_custom_opts, server_custom_opts = pcall(require, "lsp.settings." .. server)
				if has_custom_opts then
					opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
				end
				lspconfig[server].setup(opts)
			end
		end,
	},
	{
		"smjonas/inc-rename.nvim",
		init = function()
			require("inc_rename").setup()
		end,
	},
}
