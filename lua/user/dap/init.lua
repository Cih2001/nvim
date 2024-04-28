local M = {}

local function load_module(module_name)
	local ok, module = pcall(require, module_name)
	assert(ok, string.format("dependency error: %s not installed", module_name))
	return module
end

local function setup_dap_ui(dapui)
	dapui.setup({
		-- basic ui. Setup more advanced in your custom configs
		layouts = {
			{
				elements = {
					"watches",
				},
				size = 5,
				position = "bottom",
			},
			{
				elements = {
					"repl",
				},
				size = 5,
				position = "bottom",
			},
		},
		controls = {
			-- Requires Neovim nightly (or 0.8 when released)
			enabled = true,
			-- Display controls in this element
			element = "repl",
			icons = {
				pause = "",
				play = " <F5>",
				step_over = " <F6>",
				step_into = " <F7>",
				step_out = " <F8>",
				step_back = "",
				run_last = "",
				terminate = "",
			},
		},
		windows = { indent = 1 },
		render = {
			max_type_length = nil, -- Can be integer or nil.
		},
	})
end

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

local function python_path()
	-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
	-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
	-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
	local cwd = vim.fn.getcwd()
	if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
		return cwd .. "/venv/bin/python"
	elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
		return cwd .. "/.venv/bin/python"
	else
		return "/usr/bin/python"
	end
end

local function setup_python_configuration(dap)
	dap.adapters.python = function(cb, config)
		if config.request == "attach" then
			---@diagnostic disable-next-line: undefined-field
			local port = (config.connect or config).port
			---@diagnostic disable-next-line: undefined-field
			local host = (config.connect or config).host or "127.0.0.1"
			cb({
				type = "server",
				port = assert(port, "`connect.port` is required for a python `attach` configuration"),
				host = host,
				options = {
					source_filetype = "python",
				},
			})
		else
			cb({
				type = "executable",
				command = os.getenv("VIRTUAL_ENV") .. "/bin/python",
				args = { "-m", "debugpy.adapter" },
				options = {
					source_filetype = "python",
				},
			})
		end
	end

	dap.configurations.python = {
		{
			-- The first three options are required by nvim-dap
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "Launch file",
			-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
			program = "${file}", -- This configuration will launch the current file if used.
			pythonPath = python_path,
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
	esgbook = "user.dap.config.esgbook",
	jiyan = "user.dap.config.jiyan",
}

function M.setup()
	local dapui = load_module("dapui")
	setup_dap_ui(dapui)

	local ndvts = load_module("nvim-dap-virtual-text")
	ndvts.setup()

	setup_highlights()

	local dap = load_module("dap")
	setup_go_configuration(dap)
	setup_cpp_configuration(dap)
	setup_python_configuration(dap)

	local cwd = string.lower(vim.fn.getcwd())
	for k, v in pairs(custom_configs) do
		if string.find(cwd, k) then
			require(v).setup(dap, dapui)
		end
	end
end

function M.debug_python()
	local configs = require("user.dap.config.python")
	local menu = {}
	for _, c in ipairs(configs) do
		table.insert(menu, c.name)
	end

	vim.ui.select(menu, { prompt = "select an action" }, function(choice)
		-- if choice == "new" then
		-- 	vim.ui.input({ prompt = "enter new command: " }, function(choice)
		-- 		local module, args = choice:match("python%s%-m%s(%S+)%s(.+)")
		-- 		if module and args then
		-- 			local argsTable = {}
		-- 			for arg in args:gmatch("(%S+)") do
		-- 				table.insert(argsTable, arg)
		-- 			end

		-- 			local command = {
		-- 				name = choice,
		-- 				module = module,
		-- 				args = argsTable,
		-- 			}

		-- 			table.insert(configs, command)
		-- 			io:open() vim.print(configs)
		-- 		else
		-- 			vim.print("Error: Input string does not match the expected format")
		-- 		end
		-- 	end)
		-- 	return
		-- end
		for _, c in ipairs(configs) do
			if c.name == choice then
				local dap = load_module("dap")
				dap.run({
					type = "python",
					name = "module",
					request = "launch",
					module = c.module,
					args = c.args,
					pythonPath = python_path,
				})
			end
		end
	end)
end

M.setup()

return M
