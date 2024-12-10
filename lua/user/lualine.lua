local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local hide_in_width = function()
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

local bitcoin_price = "00000.00$"
local function getBitcoinPrice()
	local url = "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT"
	local command = "curl -s '" .. url .. "'"
	vim.fn.jobstart(command, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, output)
			local success, data = pcall(vim.fn.json_decode, output)
			if success and data and data.price then
				bitcoin_price = string.format("%.2f$", data.price)
			end
		end,
	})
end

local interval = 60 * 1000 -- 1 minute
local timer = vim.loop.new_timer()
timer:start(0, interval, vim.schedule_wrap(getBitcoinPrice))

local function bitcoin()
	return bitcoin_price
end

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
			"NvimTree",
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
		lualine_z = { { bitcoin, icon = { "" } } },
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
