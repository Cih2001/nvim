return {
	"NickvanDyke/opencode.nvim",
	lazy = true,
	dependencies = {
		-- Recommended for better prompt input, and required to use `opencode.nvim`'s embedded terminal — otherwise optional
		{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
	},
	keys = {
		{
			"<leader>oa",
			function()
				require("opencode").ask()
			end,
			mode = { "n", "x" },
			desc = "Ask about this",
		},
		{
			"<leader>ob",
			function()
				require("opencode").prompt("@buffer ")
			end,
			desc = "Add buffer to prompt",
		},
		{ "<leader>os", '<cmd>lua require("opencode").select()<cr>', mode = { "n", "v" }, desc = "Select prompt" },
		{
			"<leader>od",
			function()
				local node = vim.treesitter.get_node()
				-- Walk up to find the function node
				while node do
					local t = node:type()
					if t:match("function") or t:match("method") then
						break
					end
					node = node:parent()
				end
				if not node then
					vim.notify("No function found under cursor", vim.log.levels.WARN)
					return
				end
				local start_row = node:start()
				local end_row = node:end_()
				local file = vim.fn.expand("%:p")
				-- Lines are 0-indexed from treesitter, make 1-indexed
				local ref = file .. ":" .. (start_row + 1) .. "-" .. (end_row + 1)
				require("opencode").prompt(
					"Write only the doc comment (no code) for the function at "
						.. ref
						.. ". Don't explain the technical steps, just describe the purpose of the function.",
					{ append = false }
				)
			end,
			desc = "Doc comment for function",
		},
	},
	config = function()
		---@diagnostic disable-next-line: inject-field
		vim.g.opencode_opts = {
			-- provider = {
			-- 	enabled = "tmux", -- Default if inside a `tmux` session.
			-- 	tmux = {
			-- 		options = "-h", -- Options to pass to `tmux split-window`.
			-- 	},
			-- },
		}

		-- Required for `opts.auto_reload`
		vim.opt.autoread = true

		-- Buffer-local scroll mappings for opencode terminal window only
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "opencode_terminal",
			callback = function(args)
				-- Use <C-u>/<C-d> to scroll messages half page up/down within opencode terminal
				local opts = { silent = true, buffer = args.buf }
				vim.keymap.set("n", "<C-u>", '<cmd>lua require("opencode").command("session.half.page.up")<cr>', opts)
				vim.keymap.set("n", "<C-d>", '<cmd>lua require("opencode").command("session.half.page.down")<cr>', opts)

				-- Normal + Terminal mode mappings so they work inside opencode console
				for _, m in ipairs({ "t" }) do
					vim.keymap.set(m, "<C-h>", [[<C-\><C-n><cmd>TmuxNavigateLeft<cr>]], opts)
					vim.keymap.set(m, "<C-l>", [[<C-\><C-n><cmd>TmuxNavigateRight<cr>]], opts)
					-- we don't modify ctrl+j and ctrl-k bindinds, because they are going to be used to
					-- create a new line in the prompt instead
				end
			end,
		})
	end,
}
