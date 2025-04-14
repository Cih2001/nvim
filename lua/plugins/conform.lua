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

				goimports = {
					args = { "$FILENAME" },
				},
			},

			-- go imports takes a long time to finish sometimes,
			-- it's better to run after save then
			format_after_save = {
				lsp_format = "fallback",
			},

			log_level = vim.log.levels.DEBUG,
		})
	end,
}
