local function hide_in_width()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = false,
	update_in_insert = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
	cond = hide_in_width,
}

local location = {
	"location",
	padding = 0,
}

local branch = {
	"branch",
	fmt = function(branch, _)
		if string.len(branch) > 15 then
			branch = string.format("%.15s...", branch) -- fix string format and substring
		end
		return branch
	end,
}

local bitcoin = require("bitcoin")

return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local lualine = require("lualine")

		lualine.setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = "",
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					"alpha",
					"dashboard",
					"NERDTree",
					"Outline",
					"neo-tree",
					"dbui",
					"dbee",
				},
				always_divide_middle = true,
				ignore_focus = {
					"dapui_watches",
					"dapui_breakpoints",
					"dapui_scopes",
					"dapui_console",
					"dapui_stacks",
					"dap-repl",
					"oil",
				},
			},
			sections = {
				lualine_a = { branch },
				lualine_b = { diagnostics },
				lualine_c = { { "filetype", icon_only = true }, { "filename", path = 1 } },
				-- lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_x = { diff, "encoding" },
				lualine_y = { location },
				lualine_z = { { bitcoin.price, icon = { "" } } },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "quickfix", "nvim-tree" },
		})
	end,
}
