local harpoon = require("harpoon")

local ver = vim.version()
local version = string.format("  NVIM v%d.%d.%d ", ver.major, ver.minor, ver.patch)

local function normalize_path(item)
	local Path = require("plenary.path")
	return Path:new(item):make_relative(vim.loop.cwd())
end

harpoon:setup()

vim.keymap.set("n", "<S-l>", function()
	if harpoon:list():get_by_display(normalize_path(vim.api.nvim_buf_get_name(0))) then
		harpoon:list():next({ ui_nav_wrap = true })
	else
		harpoon:list():select(1)
	end
end)

vim.keymap.set("n", "<S-h>", function()
	if harpoon:list():get_by_display(normalize_path(vim.api.nvim_buf_get_name(0))) then
		harpoon:list():prev({ ui_nav_wrap = true })
	else
		local len = harpoon:list():length()
		harpoon:list():select(len)
	end
end)

vim.keymap.set("n", "m", function()
	harpoon:list():append()
end)

vim.keymap.set("n", "<space>v", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<S-q>", function()
	harpoon:list():remove()
end)

local colors = {
	black = "#000000",
	white = "#ffffff",
	bg_sel = "#1a1a1a",
	temp = "#287c34",
	fg = "#696969",
}

local function make_row(text, opts)
	local row = { text }
	for k, v in pairs(opts) do
		row[k] = v
	end
	return row
end

local function create_pane(f, filename, opts)
	f.set_fg(colors.fg)
	f.add({ "", fg = colors.black, bg = colors.bg_sel })
	if filename then
		f.add(make_row(" " .. f.icon(filename) .. " ", opts))
		f.add(make_row(vim.fn.fnamemodify(filename, ":t") .. " ", opts))
		if opts.modified then
			f.add(make_row("", opts))
		end
	end
	f.add({ "", bg = colors.bg_sel, fg = colors.black })
end

local function is_modified(path)
	local bufnr = vim.fn.bufnr(path)
	if bufnr == -1 then
		return false
	end

	local info = vim.fn.getbufinfo(bufnr)
	if info[1].changed == 0 then
		return false
	end

	return true
end

local render = function(f)
	f.add({ version, fg = "#bb0000" })

	local marks = harpoon:list().items
	local found = false
	local current_file = normalize_path(vim.api.nvim_buf_get_name(0))
	for _, mark in ipairs(marks) do
		local selected = current_file == mark.value
		found = found or selected
		local fg = selected and f.icon_color(mark.value) or nil

		local opts = { fg = fg, bg = colors.bg_sel }
		if is_modified(mark.value) then
			opts.modified = true
		end
		create_pane(f, mark.value, opts)
	end

	if not found then
		local opts = { fg = colors.temp, bg = colors.bg_sel, gui = "italic" }
		if is_modified(vim.api.nvim_buf_get_name(0)) then
			opts.modified = true
		end
		create_pane(f, current_file, opts)
	end

	f.add_spacer()

	f.make_tabs(function(info)
		f.add({ "", fg = colors.black, bg = colors.bg_sel })
		f.add({ " " .. info.index .. " ", fg = info.current and colors.white or nil, bg = colors.bg_sel })
		f.add({ "", bg = colors.bg_sel, fg = colors.black })
	end)
end

require("tabline_framework").setup({
	render = render,
	hl = { fg = "#abb2bf", bg = "#181A1F" },
	hl_sel = { fg = "#abb2bf", bg = "#282c34" },
	hl_fill = { fg = "#ffffff", bg = "#000000" },
})
