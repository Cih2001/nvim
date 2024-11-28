local harpoon = require("harpoon")
harpoon:setup()

local ver = vim.version()
local version = string.format("  NeoVim v%d.%d.%d ", ver.major, ver.minor, ver.patch)

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
		fill = bg_fill,
		bg = bg_sel,
		fg = fg,
		red = "#BB1A1F",
		-- red = "#4ec9b0",
	}
end

Colors = load_colors()

local function draw_pane(f, text, fg, bg)
	f.add({ "", bg = bg, fg = Colors.fill })
	f.add({ text, bg = bg, fg = fg })
	f.add({ "", bg = Colors.fill, fg = bg })
end

--      
-- local function create_panes(f, panes)
-- 	for idx, pane in ipairs(panes) do
-- 		local text = pane.filename
-- 		if idx > 1 then
-- 			text = " " .. f.icon(pane.filename) .. " " .. vim.fn.fnamemodify(pane.filename, ":t") .. " "
-- 			text = pane.modified and text .. "" or text
-- 		end
--
-- 		local fg = Colors.fg
-- 		local bg = Colors.bg
-- 		if pane.selected then
-- 			fg, bg = bg, fg
-- 		end
-- 		if idx == 1 then
-- 			bg = Colors.fill
-- 			fg = Colors.red
-- 		end
-- 		f.add({ "", bg = Colors.fill, fg = bg })
-- 		f.add({ text, bg = bg, fg = fg })
-- 		f.add({ "", bg = Colors.fill, fg = bg })
-- 	end
-- end

local function create_panes_old(f, panes)
	for idx, pane in ipairs(panes) do
		local fg = Colors.fg
		local bg = Colors.bg
		local gui = nil
		if pane.selected then
			fg, bg = bg, fg
			gui = "bold"
		end

		local text = pane.filename
		if idx > 1 then
			f.add({ " " .. f.icon(pane.filename), bg = bg, fg = f.icon_color(pane.filename) })
			text = " " .. vim.fn.fnamemodify(pane.filename, ":t") .. " "
			text = pane.modified and text .. "󰪥 " or text
		end

		if idx == 1 then
			bg = Colors.fill
		end
		f.add({ text, bg = bg, fg = fg, gui = gui })

		fg = Colors.fg
		if idx == 1 then
			fg = Colors.fill
		elseif not pane.selected then
			fg = Colors.bg
		end

		bg = Colors.bg
		if idx == #panes then
			bg = Colors.fill
		elseif idx < #panes and panes[idx + 1].selected then
			bg = Colors.fg
		end
		f.add({ "", bg = bg, fg = fg })
	end
end

local render = function(f)
	local marks = harpoon:list().items
	local found = false
	local current_file = normalize_path(vim.api.nvim_buf_get_name(0))
	local panes = {
		{
			filename = version,
			selected = false,
			modified = false,
			is_mark = true,
		},
	}
	for _, mark in ipairs(marks) do
		local selected = current_file == mark.value
		found = found or selected
		table.insert(panes, {
			filename = mark.value,
			selected = selected,
			modified = is_modified(mark.value),
			is_mark = true,
		})
	end

	if not found then
		table.insert(panes, {
			filename = current_file,
			selected = true,
			is_modified(vim.api.nvim_buf_get_name(0)),
			is_mark = false,
		})
	end

	create_panes_old(f, panes)
	f.add_spacer()

	f.make_tabs(function(info)
		local fg = info.current and Colors.bg or Colors.fg
		local bg = info.current and Colors.fg or Colors.bg
		draw_pane(f, " " .. info.index .. " ", fg, bg)
	end)
end

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	callback = function()
		Colors = load_colors()
		require("tabline_framework").setup({
			render = render,
			hl_fill = { fg = Colors.fg, bg = Colors.fill },
		})
	end,
})

require("tabline_framework").setup({
	render = render,
	hl_fill = { fg = Colors.fg, bg = Colors.fill },
})

M = {}

M.add = function()
	harpoon:list():add()
end

M.toggle = function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end

M.next = function()
	local current_buff = normalize_path(vim.api.nvim_buf_get_name(0))
	local length = harpoon:list():length()
	local idx
	_, idx = harpoon:list():get_by_value(current_buff)
	if idx and idx + 1 <= length then
		harpoon:list():select(idx + 1)
	else
		harpoon:list():select(1)
	end
end

M.prev = function()
	local current_buff = normalize_path(vim.api.nvim_buf_get_name(0))
	local length = harpoon:list():length()
	local idx
	_, idx = harpoon:list():get_by_value(current_buff)
	if idx and idx - 1 >= 1 then
		harpoon:list():select(idx - 1)
	else
		harpoon:list():select(length)
	end
end

M.remove = function()
	local current_buff = normalize_path(vim.api.nvim_buf_get_name(0))
	local length = harpoon:list():length()
	local idx
	_, idx = harpoon:list():get_by_value(current_buff)
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
