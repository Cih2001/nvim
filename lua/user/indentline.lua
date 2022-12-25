local status_ok, indent_blankline = pcall(require, "indent_blankline")
if not status_ok then
	return
end

vim.g.indentLine_enabled = 1
-- vim.g.indent_blankline_char = "│"
vim.g.indent_blankline_char = "▏"
indent_blankline.setup({
	-- show_end_of_line = true,
	-- space_char_blankline = " ",
	-- show_current_context = true,
	-- show_char_blankline = " "
	-- show_current_context_start = true,
	-- char_highlight_list = {
	--   "IndentBlanklineIndent1",
	--   "IndentBlanklineIndent2",
	--   "IndentBlanklineIndent3",
	-- },
})
