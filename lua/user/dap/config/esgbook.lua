local M = {}

function M.setup(dap, _)
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
