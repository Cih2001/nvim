return {
	"NickvanDyke/opencode.nvim",
	lazy = true,
	dependencies = {
		-- Recommended for better prompt input, and required to use `opencode.nvim`'s embedded terminal — otherwise optional
		{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
	},
	keys = {
		{ "<leader>ot", '<cmd>lua require("opencode").toggle()<cr>', mode = { "n", "v" }, desc = "Toggle embedded" },
		{
			"<leader>oa",
			'<cmd>lua require("opencode").ask("@this: ")<cr>',
			mode = { "n", "x" },
			desc = "Ask about this",
		},
		{
			"<leader>ob",
			'<cmd>lua require("opencode").prompt("@buffer", { append = true })<cr>',
			desc = "Add buffer to prompt",
		},
		{ "<leader>on", '<cmd>lua require("opencode").command("session_new")<cr>', desc = "New session" },
		{ "<leader>os", '<cmd>lua require("opencode").select()<cr>', mode = { "n", "v" }, desc = "Select prompt" },
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
