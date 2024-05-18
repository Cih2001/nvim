local harpoon = require("harpoon")

local ver = vim.version()
local version = string.format("  NVIM v%d.%d.%d ", ver.major, ver.minor, ver.patch)

local function normalize_path(item)
	local Path = require("plenary.path")
	return Path:new(item):make_relative(vim.loop.cwd())
end

harpoon:setup()

vim.keymap.set("n", "<S-l>", function()
	if harpoon:list():get_by_value(normalize_path(vim.api.nvim_buf_get_name(0))) then
		harpoon:list():next({ ui_nav_wrap = true })
	else
		harpoon:list():select(1)
	end
end)

vim.keymap.set("n", "<S-h>", function()
	if harpoon:list():get_by_value(normalize_path(vim.api.nvim_buf_get_name(0))) then
		harpoon:list():prev({ ui_nav_wrap = true })
	else
		local len = harpoon:list():length()
		harpoon:list():select(len)
	end
end)

vim.keymap.set("n", "m", function()
	harpoon:list():add()
end)

vim.keymap.set("n", "<space>v", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<S-q>", function()
	harpoon:list():remove()
end)

local function load_colors()
	local bg = "#181A1F"
	local tabline = vim.api.nvim_get_hl_by_name("TabLine", true)
	if tabline and tabline.background then
		bg = string.format("#%06x", tabline.background)
	end

	local bg_sel = "#282c34"
	local tablineSel = vim.api.nvim_get_hl_by_name("TabLineSel", true)
	if tablineSel and tablineSel.background then
		bg_sel = string.format("#%06x", tablineSel.background)
	end

	local fg = "#696969"
	if tablineSel and tablineSel.foreground then
		fg = string.format("#%06x", tablineSel.foreground)
	end

	return {
		bg = bg,
		bg_sel = bg_sel,
		fg = fg,
		red = "#bb0000",
	}
end

Colors = load_colors()

local function make_row(text, opts)
	local row = { text }
	for k, v in pairs(opts) do
		row[k] = v
	end
	return row
end

local function create_pane(f, filename, opts)
	f.set_fg(Colors.fg)
	f.add({ "", fg = Colors.bg, bg = Colors.bg_sel })
	if filename then
		f.add(make_row(" " .. f.icon(filename) .. " ", opts))
		f.add(make_row(vim.fn.fnamemodify(filename, ":t") .. " ", opts))
		if opts.modified then
			f.add(make_row("", opts))
		end
	end
	f.add({ "", bg = Colors.bg_sel, fg = Colors.bg })
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
		local fg = selected and Colors.red

		local opts = { fg = fg, bg = Colors.bg_sel }
		if is_modified(mark.value) then
			opts.modified = true
		end
		create_pane(f, mark.value, opts)
	end

	if not found then
		local opts = { fg = Colors.red, bg = Colors.bg_sel, gui = "italic" }
		if is_modified(vim.api.nvim_buf_get_name(0)) then
			opts.modified = true
		end
		create_pane(f, current_file, opts)
	end

	f.add_spacer()

	f.make_tabs(function(info)
		f.add({ "", fg = Colors.bg, bg = Colors.bg_sel })
		f.add({ " " .. info.index .. " ", fg = info.current and Colors.fg or nil, bg = Colors.bg_sel })
		f.add({ "", bg = Colors.bg_sel, fg = Colors.bg })
	end)
end

vim.cmd([[
  augroup MyAutoCmds
    autocmd!
    autocmd ColorScheme * lua require('user.harpoon').on_colorscheme_changed()
  augroup END
]])

require("tabline_framework").setup({
	render = render,
	hl_fill = { fg = Colors.fg, bg = Colors.bg },
})

M = {}

function M.on_colorscheme_changed()
	Colors = load_colors()
	require("tabline_framework").setup({
		render = render,
		hl_fill = { fg = Colors.fg, bg = Colors.bg },
	})
end

return M
