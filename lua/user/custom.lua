local M = {
	menu = { "run test", "debug test", "test current file" },
}

local function browsePREnv()
	vim.fn.jobstart("gh pr view --json number --jq .number", {
		stdout_buffered = true,
		on_stdout = function(_, output)
			local link = string.format("https://pr-%s.dev.esgbook.arabesque.com/", output[1])
			vim.fn.jobstart({ "open", link })
		end,
	})
end

local function browsePROcto()
	vim.fn.jobstart("gh pr view --json number --jq .number", {
		stdout_buffered = true,
		on_stdout = function(_, output)
			local cmd = string.format("Octo pr edit %s", output[1])
			vim.cmd(cmd)
		end,
	})
end

local function getGithubLink()
	local base = "https://github.com/arabesque-sray/esgbook/blob/main/%s#L%d"
	local path = vim.api.nvim_eval("expand('%')")
	local apiIndex = string.find(path, "/api")
	if apiIndex then
		path = string.sub(path, apiIndex + 1)
	end
	local line = vim.fn.line(".")
	vim.fn.jobstart({ "open", string.format(base, path, line) })
end

function M.custom()
	vim.ui.select(M.menu, { prompt = "select an action" }, function(choice)
		if choice == "run test" then
			vim.cmd("Neotest run")
		elseif choice == "debug test" then
			require("neotest").run.run({ strategy = "dap" })
		elseif choice == "test current file" then
			require("neotest").run.run(vim.fn.expand("%"))
		end
	end)
end

return M
