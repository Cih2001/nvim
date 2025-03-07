return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				markdown = { "prettier" },
				javascript = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				yaml = { "prettier" },
				json = { "prettier" },
				-- Conform will run multiple formatters sequentially
				go = { "gofumpt", "goimports" },
				terraform = { "terraform_fmt" },
			},

			formatters = {
				prettier = {
					prepend_args = { "--no-bracket-spacing" },
				},
			},

			format_on_save = {
				timeout_ms = 1000,
				lsp_format = "fallback",
				async = false,
			},
		})
	end,
}
