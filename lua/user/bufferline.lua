local Path = require("plenary.path")

local function get_marks()
	local h = require("harpoon")
	local config = h.get_mark_config()
	return config.marks
end

local function normalize_path(item)
	return Path:new(item):make_relative(vim.loop.cwd())
end

local colors = {
	black = "#000000",
	white = "#ffffff",
	bg = "#181A1F",
	bg_sel = "#282c34",
	fg = "#696969",
}

local render = function(f)
	f.add({ "  Radioactive ", fg = "#bb0000" })

	local items = get_marks()
	local found = false
	for _, item in ipairs(items) do
		f.make_tabs(function(info)
			local current_file = normalize_path(vim.api.nvim_buf_get_name(0))
			local current = current_file == item.filename
			if not found and current then
				found = true
			end

			f.set_fg(not info.current and colors.fg or nil)

			f.add({ "", fg = colors.black })
			if item.filename then
				f.add({
					f.icon(item.filename) .. " ",
					fg = current and f.icon_color(item.filename) or nil,
				})
				f.add({
					vim.fn.fnamemodify(item.filename, ":t"),
					fg = current and f.icon_color(item.filename) or nil,
				})
			end

			f.add({
				"",
				fg = info.current and colors.bg_sel or colors.bg,
				bg = colors.black,
			})
		end)
	end

	if not found then
		local current_file = normalize_path(vim.api.nvim_buf_get_name(0))
		f.set_fg(colors.fg)
		f.add({ "", fg = colors.black, bg = colors.bg_sel })
		f.add({
			f.icon(current_file) .. " ",
			fg = f.icon_color(current_file),
			bg = colors.bg_sel,
		})
		f.add({
			vim.fn.fnamemodify(current_file, ":t"),
			fg = f.icon_color(current_file),
			bg = colors.bg_sel,
		})
		f.add({
			"",
			fg = colors.bg_sel,
			bg = colors.black,
		})
	end

	f.add_spacer()

	local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

	f.add({ "  " .. errors, fg = "#e86671" })
	f.add({ "  " .. warnings, fg = "#e5c07b" })
	f.add(" ")
end

require("tabline_framework").setup({
	render = render,
	hl = { fg = "#abb2bf", bg = "#181A1F" },
	hl_sel = { fg = "#abb2bf", bg = "#282c34" },
	hl_fill = { fg = "#ffffff", bg = "#000000" },
})
