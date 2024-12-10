local status_ok, conform = pcall(require, "conform")
if not status_ok then
	return
end

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		markdown = { "prettier" },
		javascript = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		yaml = { "prettier" },
		json = { "prettier" },
		-- Conform will run multiple formatters sequentially
		go = { "goimports", "gofumpt" },
		terraform = { "terraform_fmt" },
	},

	formatters = {
		prettier = {
			prepend_args = { "--no-bracket-spacing" },
		},
	},

	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
		async = false,
	},
})
