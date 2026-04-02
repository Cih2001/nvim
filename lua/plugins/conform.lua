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
				yaml = { vim.fn.executable("helmfmt") == 1 and "helmfmt" or "prettier" },
				json = { "prettier" },
				-- Conform will run multiple formatters sequentially
				go = { "gofumpt", "goimports" },
				terraform = { "terraform_fmt" },
				c = { "clang-format" },
			},

			formatters = {
				prettier = {
					prepend_args = { "--no-bracket-spacing" },
				},
				goimports = {
					args = { "-local", "github.com/arabesque-sray", "$FILENAME" },
				},
				helmfmt = {
					command = "sh",
					args = {
						"-c",
						'helmfmt --files "$1" >/dev/null 2>&1',
						"--",
						"$FILENAME",
					},
					stdin = false,
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
