-- import null-ls plugin safely
local ok, null_ls = pcall(require, "null-ls")
if not ok then
	return
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.gofumpt,
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.formatting.terraform_fmt,
		null_ls.builtins.formatting.prettier.with({
			extra_args = { "--no-bracket-spacing" },
		}),
		null_ls.builtins.code_actions.gitsigns,
		-- null_ls.builtins.formatting.protolint,
		-- null_ls.builtins.formatting.clang_format,
		-- null_ls.builtins.diagnostics.cpplint,
		-- null_ls.builtins.formatting.rustfmt,
		-- null_ls.builtins.diagnostics.pylint,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})
