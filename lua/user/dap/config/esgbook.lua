local M = {}

local function load_module(module_name)
	local ok, module = pcall(require, module_name)
	assert(ok, string.format("dependency error: %s not installed", module_name))
	return module
end

function M.setup(dap, dapui)
	dap.adapters.delve = {
		type = "server",
		host = "127.0.0.1",
		port = 2345,
	}

	dap.configurations.go = {
		{
			name = "Okteto",
			type = "delve",
			request = "attach",
			mode = "remote",
			substitutePath = {
				{ from = "/Users/hamidrezaebtehaj/go/src/github.com/esgbook/api", to = "/usr/src/app" },
			},
			port = "2345",
			host = "127.0.0.1",
		},
		{
			type = "go",
			name = "Debug",
			request = "launch",
			program = "${file}",
		},
	}
end

return M
