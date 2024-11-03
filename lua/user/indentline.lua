local status_ok, ibl = pcall(require, "ibl")
if not status_ok then
	return
end

local highlight = {
	"IblIndent",
	"IblIndent",
}

ibl.setup({
	indent = { highlight = highlight, char = "▏" },
	whitespace = {
		highlight = highlight,
		remove_blankline_trail = false,
	},
	scope = { enabled = false },
})
