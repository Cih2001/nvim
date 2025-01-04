local M = {}

function M.setup(dap, dapui)
	dapui.setup({
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
					"stacks",
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
	})
end

return M
