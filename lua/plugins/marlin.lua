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
--
-- --            
-- -- local function create_panes(f, panes)
-- -- 	for idx, pane in ipairs(panes) do
-- -- 		local text = pane.filename
-- -- 		if idx > 1 then
-- -- 			text = " " .. f.icon(pane.filename) .. " " .. vim.fn.fnamemodify(pane.filename, ":t") .. " "
-- -- 			text = pane.modified and text .. "" or text
-- -- 		end
-- --
-- -- 		local fg = Colors.fg
-- -- 		local bg = Colors.bg
-- -- 		if pane.selected then
-- -- 			fg, bg = bg, fg
-- -- 		end
-- -- 		if idx == 1 then
-- -- 			bg = Colors.fill
-- -- 			fg = Colors.red
-- -- 		end
-- -- 		f.add({ "", bg = Colors.fill, fg = bg })
-- -- 		f.add({ text, bg = bg, fg = fg })
-- -- 		f.add({ "", bg = Colors.fill, fg = bg })
-- -- 	end
-- -- end
--
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
			text = pane.is_mark and text or text .. " "
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

local function render(f)
	local marlin = require("marlin")
	local marks = marlin.get_indexes()
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
		local markpath = normalize_path(mark.filename)
		local selected = current_file == markpath
		found = found or selected
		table.insert(panes, {
			filename = markpath,
			selected = selected,
			modified = is_modified(mark.filename),
			is_mark = true,
		})
	end

	if not found then
		table.insert(panes, {
			filename = current_file,
			selected = true,
			modified = is_modified(current_file),
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

local function list()
	local results = require("marlin").get_indexes()
	local content = {}

	local fzf_lua = require("fzf-lua")
	local builtin = require("fzf-lua.previewer.builtin")
	local fzfpreview = builtin.buffer_or_file:extend()

	function fzfpreview:new(o, opts, fzf_win)
		fzfpreview.super.new(self, o, opts, fzf_win)
		setmetatable(self, fzfpreview)
		return self
	end

	function fzfpreview.parse_entry(_, entry_str)
		if entry_str == "" then
			return {}
		end

		local entry = content[entry_str]
		return {
			path = entry.filename,
			line = entry.row or 1,
			col = 1,
		}
	end

	fzf_lua.fzf_exec(function(fzf_cb)
		for i, b in ipairs(results) do
			local entry = i .. ":" .. b.filename .. ":" .. b.row

			content[entry] = b
			fzf_cb(entry)
		end
		fzf_cb()
	end, {
		previewer = fzfpreview,
		prompt = "Marlin(navigate: <Up>, <Down> remove: Ctrl-x)> ",
		actions = {
			["ctrl-x"] = {
				fn = function(selected)
					require("marlin").remove(content[selected[1]].filename)
				end,
				reload = true,
				silent = true,
			},
			["Up"] = {
				fn = function(selected)
					require("marlin").move_up(content[selected[1]].filename)
				end,
				reload = true,
				silent = true,
			},
			["Down"] = {
				fn = function(selected)
					require("marlin").move_down(content[selected[1]].filename)
				end,
				reload = true,
				silent = true,
			},
		},
	})
end

return {
	"desdic/marlin.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"rafcamlet/tabline-framework.nvim",
	},
	lazy = false,
	opts = {},
	config = function(_, opts)
		local marlin = require("marlin")
		marlin.setup(opts)

		local function reload()
			Colors = load_colors()
			require("tabline_framework").setup({
				render = render,
				hl_fill = { fg = Colors.fg, bg = Colors.fill },
			})
		end

		reload()
		vim.api.nvim_create_autocmd({ "ColorScheme" }, {
			callback = reload,
		})
	end,
	keys = {
		{ "<S-l>", '<cmd>lua require("marlin").next()<cr>' },
		{ "<S-h>", '<cmd>lua require("marlin").prev()<cr>' },
		{ "m", '<cmd>lua require("marlin").add()<cr>' },
		{
			"<S-q>",
			function()
				local marlin = require("marlin")
				marlin.remove()
				marlin.prev()
			end,
		},
		{ "<space>v", list },
	},
}
