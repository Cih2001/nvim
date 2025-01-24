local function setup_go_configuration(dap)
	dap.adapters.go = function(callback, config)
		local stdout = vim.loop.new_pipe(false)
		local handle
		local pid_or_err
		local host = config.host or "127.0.0.1"
		local port = config.port or "38697"
		local addr = string.format("%s:%s", host, port)
		local opts = {
			stdio = { nil, stdout },
			args = { "dap", "-l", addr },
			detached = true,
		}
		handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
			stdout:close()
			handle:close()
			if code ~= 0 then
				print("dlv exited with code", code)
			end
		end)
		assert(handle, "Error running dlv: " .. tostring(pid_or_err))
		stdout:read_start(function(err, chunk)
			assert(not err, err)
			if chunk then
				vim.schedule(function()
					require("dap.repl").append(chunk)
				end)
			end
		end)
		-- Wait for delve to start
		vim.defer_fn(function()
			callback({ type = "server", host = "127.0.0.1", port = port })
		end, 100)
	end

	dap.configurations.go = {
		{
			type = "go",
			name = "Debug",
			request = "launch",
			program = "${file}",
		},
		{
			type = "go",
			name = "Attach",
			mode = "local",
			request = "attach",
			processId = require("dap.utils").pick_process,
		},
		{
			type = "go",
			name = "Debug test",
			request = "launch",
			mode = "test",
			program = "${file}",
		},
		{
			type = "go",
			name = "Debug test (go.mod)",
			request = "launch",
			mode = "test",
			program = "./${relativeFileDirname}",
		},
	}
end

local function setup_cpp_configuration(dap)
	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		executable = {
			command = vim.fn.exepath("codelldb"),
			args = { "--port", "${port}" },
		},
	}

	dap.configurations.cpp = {
		{
			name = "LLDB: Launch",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},
			preRunCommands = { "breakpoint name configure --disable cpp_exception" },
		},
	}
end

local function setup_highlights()
	vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
	vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
	vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

	vim.fn.sign_define(
		"DapBreakpoint",
		{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
	)
	vim.fn.sign_define(
		"DapBreakpointCondition",
		{ text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
	)
	vim.fn.sign_define(
		"DapBreakpointRejected",
		{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
	)
	vim.fn.sign_define(
		"DapLogPoint",
		{ text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
	)
	vim.fn.sign_define(
		"DapStopped",
		{ text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
	)
end

local custom_configs = {
	esgbook = "dap_configs.esgbook",
	jiyan = "dap_configs.jiyan",
}

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"igorlfs/nvim-dap-view",
			"theHamsta/nvim-dap-virtual-text",
		},
		keys = {
			{ "<F1>", "<cmd>DapViewToggle<cr>" },
			{ "<F2>", '<cmd>lua require"dap".toggle_breakpoint()<cr>' },
			{ "<F3>", '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint Condition: "))<cr>' },
			{ "<F4>", '<cmd>lua require"dap".run_to_cursor()<cr>' },
			{ "<F5>", '<cmd>lua require"dap".continue()<cr>' },
			{ "<F6>", '<cmd>lua require"dap".step_over()<cr>' },
			{ "<F7>", '<cmd>lua require"dap".step_into()<cr>' },
			{ "<F8>", '<cmd>lua require"dap".step_out()<cr>' },
		},
		lazy = true,
		config = function()
			local ndvts = require("nvim-dap-virtual-text")
			ndvts.setup()

			setup_highlights()

			local dap = require("dap")
			local cwd = string.lower(vim.fn.getcwd())
			for k, v in pairs(custom_configs) do
				if string.find(cwd, k) then
					require(v).setup(dap)
					return
				end
			end

			setup_go_configuration(dap)
			setup_cpp_configuration(dap)
		end,
	},
}
