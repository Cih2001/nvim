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
				size = 10,
				position = "bottom",
			},
			{
				elements = {
					"repl",
				},
				size = 10,
				position = "bottom",
			},
		},
		controls = {
			enabled = vim.fn.exists("+winbar") == 1,
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

local python_path = function()
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
	esgbook = "dap.config.esgbook",
	jiyan = "dap.config.jiyan",
}

return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
	},
	lazy = true,
	config = function()
		local dapui = load_module("dapui")
		setup_dap_ui(dapui)

		local ndvts = load_module("nvim-dap-virtual-text")
		ndvts.setup()

		setup_highlights()

		local dap = load_module("dap")
		local cwd = string.lower(vim.fn.getcwd())
		for k, v in pairs(custom_configs) do
			if string.find(cwd, k) then
				require(v).setup(dap, dapui)
				return
			end
		end

		setup_go_configuration(dap)
		setup_cpp_configuration(dap)
	end,
}
