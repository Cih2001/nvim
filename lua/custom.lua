local M = {
	menu = { "Run test", "Github Link", "Open PR Env" },
	git_menu = { "Status", "Branches", "Commits", "Blame" },
}

local function browsePREnv()
	vim.system({ "gh", "pr", "view", "--json", "number", "--jq", ".number" }, {
		stdout = function(err, data)
			if err then
				vim.print(err)
				return
			end

			if data == nil then
				return
			end

			data = string.gsub(data, "%s+", "")
			local link = string.format("https://pr-%s.app.dev.esgbook.com/", data)
			vim.print(link)
			vim.system({ "open", link })
		end,
	})
end

local function getGitInfo()
	local handle = io.popen("git rev-parse --show-toplevel")
	if handle == nil then
		return nil
	end
	local gitRoot = handle:read("*a"):gsub("\n$", "") -- Remove trailing newline
	handle:close()

	handle = io.popen("git config --get remote.origin.url")
	if handle == nil then
		return nil
	end
	local remoteURL = handle:read("*a"):gsub("\n$", "")
	handle:close()

	handle = io.popen("git rev-parse --abbrev-ref HEAD")
	if handle == nil then
		return nil
	end
	local branch = handle:read("*a"):gsub("\n$", "") -- Remove trailing newline
	handle:close()

	return {
		git_root = gitRoot,
		remote_url = remoteURL
			:gsub("%.git$", "")
			:gsub(":", "/")
			:gsub("git@", "https://")
			:gsub("ssh://git@", "https://"),
		branch = branch,
	}
end

local function getGithubLink()
	local gitInfo = getGitInfo()
	if gitInfo == nil then
		vim.print("Failed to get the git info.")
		return
	end

	local filePath = vim.api.nvim_eval("expand('%:p')")
	local relativePath = filePath:sub(#gitInfo.git_root + 2) -- Trim root and append slash

	-- Get the current editor line number.
	local line = vim.fn.line(".")

	local githubLink = string.format("%s/blob/%s/%s#L%d", gitInfo.remote_url, gitInfo.branch, relativePath, line)
	vim.fn.jobstart({ "open", githubLink })
end

function M.custom()
	vim.ui.select(M.menu, { prompt = "select an action" }, function(choice)
		if choice == M.menu[1] then
			require("gotest").run_current_test()
		elseif choice == M.menu[2] then
			getGithubLink()
		elseif choice == M.menu[3] then
			browsePREnv()
		end
	end)
end

return M
