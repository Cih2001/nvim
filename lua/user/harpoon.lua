local harpoon = require("harpoon")
harpoon:setup()

local ver = vim.version()
local version = string.format("  NVIM v%d.%d.%d ", ver.major, ver.minor, ver.patch)

local function normalize_path(item)
	local path = require("plenary.path")
	return path:new(item):make_relative(vim.loop.cwd())
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

local function load_colors()
	local tabline = vim.api.nvim_get_hl_by_name("TabLine", true)
	local tablineSel = vim.api.nvim_get_hl_by_name("TabLineSel", true)

	local bg_fill = tabline and tabline.background and string.format("#%06x", tabline.background) or "#181A1F"
	local bg_sel = tablineSel and tablineSel.background and string.format("#%06x", tablineSel.background) or "#282c34"
	local fg = tablineSel and tablineSel.foreground and string.format("#%06x", tablineSel.foreground) or "#696969"

	return {
		bg_fill = bg_fill,
		bg_sel = bg_sel,
		fg = fg,
	}
end

Colors = load_colors()

local function draw_pane(f, text, fg, bg)
	f.add({ "", bg = bg, fg = Colors.bg_fill })
	f.add({ text, bg = bg, fg = fg })
	f.add({ "", bg = Colors.bg_fill, fg = bg })
end

local function create_pane(f, filename, selected, modified)
	local text = " " .. f.icon(filename) .. " " .. vim.fn.fnamemodify(filename, ":t") .. " "
	text = modified and text .. "" or text

	if selected then
		draw_pane(f, text, Colors.bg_sel, Colors.fg)
	else
		draw_pane(f, text, Colors.fg, Colors.bg_sel)
	end
end

local render = function(f)
	f.add({ version })

	local marks = harpoon:list().items
	local found = false
	local current_file = normalize_path(vim.api.nvim_buf_get_name(0))
	for _, mark in ipairs(marks) do
		local selected = current_file == mark.value
		found = found or selected
		create_pane(f, mark.value, selected, is_modified(mark.value))
	end

	if not found then
		create_pane(f, current_file, true, is_modified(vim.api.nvim_buf_get_name(0)))
	end

	f.add_spacer()

	f.make_tabs(function(info)
		local fg = info.current and Colors.bg_sel or Colors.fg
		local bg = info.current and Colors.fg or Colors.bg_sel
		draw_pane(f, " " .. info.index .. " ", fg, bg)
	end)
end

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	callback = function()
		Colors = load_colors()
		require("tabline_framework").setup({
			render = render,
			hl_fill = { fg = Colors.fg, bg = Colors.bg_fill },
		})
	end,
})

require("tabline_framework").setup({
	render = render,
	hl_fill = { fg = Colors.fg, bg = Colors.bg_fill },
})

M = {}

M.add = function()
	harpoon:list():add()
end

M.toggle = function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end

M.next = function()
	local length = harpoon:list():length()
	local idx
	_, idx = harpoon:list():get_by_value(normalize_path(vim.api.nvim_buf_get_name(0)))
	if idx and idx + 1 <= length then
		harpoon:list():select(idx + 1)
	else
		harpoon:list():select(1)
	end
end

M.prev = function()
	local length = harpoon:list():length()
	local idx
	_, idx = harpoon:list():get_by_value(normalize_path(vim.api.nvim_buf_get_name(0)))
	if idx and idx - 1 >= 1 then
		harpoon:list():select(idx - 1)
	else
		harpoon:list():select(length)
	end
end

M.remove = function()
	local length = harpoon:list():length()
	local idx
	_, idx = harpoon:list():get_by_value(normalize_path(vim.api.nvim_buf_get_name(0)))
	if not idx or idx <= 0 then
		return
	end

	local old_idx = idx
	while idx < length do
		harpoon:list():replace_at(idx, harpoon:list():get(idx + 1))
		idx = idx + 1
	end

	harpoon:list():remove_at(idx)

	if old_idx == length then
		harpoon:list():select(old_idx - 1)
	else
		harpoon:list():select(old_idx)
	end
end

return M
