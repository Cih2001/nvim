local function get_golangci_lint_path()
	local cwd = vim.fn.getcwd()
	if vim.fn.filereadable(cwd .. "/api/.golangci.yml") == 1 then
		return cwd .. "/api"
	end

	return cwd
end

return {
	"mfussenegger/nvim-lint",
	config = function()
		local lint = require("lint")
		lint.linters.golangcilint.cwd = get_golangci_lint_path()
		lint.linters_by_ft = {
			go = { "golangcilint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
