local function find_file_in_directory(dir, filename)
	local handle = io.popen('find "' .. dir .. '" -name "' .. filename .. '"')
	if handle then
		local result = handle:read("*a")
		handle:close()
		return result
	end
	return ""
end

local function get_golangci_lint_dir()
	local cwd = vim.fn.getcwd()
	local filename = ".golangci.yml"
	local paths = find_file_in_directory(cwd, filename)

	if paths ~= "" then
		-- Split the returned multiline string into a list, filter out empty lines
		local path_list = {}
		for path in paths:gmatch("([^\n]+)") do
			table.insert(path_list, path)
		end

		-- Find the shortest relative path
		table.sort(path_list, function(a, b)
			-- Compare the length of the paths relative to the cwd
			return #a < #b
		end)

		local shortest_path = path_list[1] -- first item after sorting by path length
		vim.print("golangci-lint path:" .. shortest_path)
		return shortest_path:match("(.+)/")
	else
		return nil
	end
end

return {
	"mfussenegger/nvim-lint",
	config = function()
		local lint = require("lint")
		local eslint = { "eslint_d" }

		lint.linters.golangcilint.ignore_exitcode = true
		lint.linters.golangcilint.cwd = get_golangci_lint_dir()
		lint.linters_by_ft = {
			go = { "golangcilint" },
			javascript = eslint,
			typescript = eslint,
			javascriptreact = eslint,
			typescriptreact = eslint,
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
