local M = {
	menu = { "test", "browse pr", "browse pr-env" },
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

function M.custom()
	vim.ui.select(M.menu, { prompt = "select an action" }, function(choice)
		if choice == "browse pr-env" then
			browsePREnv()
		elseif choice == "test" then
			require("user.gotest").run_current_test()
		elseif choice == "browse pr" then
			browsePROcto()
		end
	end)
end

return M
