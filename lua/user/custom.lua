local M = {
	menu = { "Run test", "Github Link", "Open PR Env" },
	git_menu = { "Status", "Branches", "Commits", "Blame" },
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
		if choice == M.menu[1] then
			require("user.gotest").run_current_test()
		elseif choice == M.menu[2] then
			getGithubLink()
		elseif choice == M.menu[3] then
			browsePREnv()
		end
	end)
end

function M.git()
	vim.ui.select(M.git_menu, { prompt = "select an action" }, function(choice)
		if choice == M.git_menu[1] then
			require("fzf-lua").git_status()
		elseif choice == M.git_menu[2] then
			require("fzf-lua").git_branches()
		elseif choice == M.git_menu[3] then
			require("fzf-lua").git_commits()
		elseif choice == M.git_menu[4] then
			require("fzf-lua").git_blame()
		end
	end)
end

return M
