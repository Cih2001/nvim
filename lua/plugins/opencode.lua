return {
	"NickvanDyke/opencode.nvim",
	dependencies = {
		-- Recommended for better prompt input, and required to use `opencode.nvim`'s embedded terminal — otherwise optional
		{ "folke/snacks.nvim", opts = { input = { enabled = true } } },
	},
	keys = {
		{ "<leader>ot", '<cmd>lua require("opencode").toggle()<cr>', desc = "Toggle embedded" },
		{ "<leader>oA", '<cmd>lua require("opencode").ask()<cr>', desc = "Ask" },
		{ "<leader>oa", '<cmd>lua require("opencode").ask("@cursor: ")<cr>', desc = "Ask about this" },
		{
			"<leader>oa",
			'<cmd>lua require("opencode").ask("@selection: ")<cr>',
			mode = "v",
			desc = "Ask about selection",
		},
		{
			"<leader>oe",
			'<cmd>lua require("opencode").prompt("Explain @cursor and its context")<cr>',
			desc = "Explain this code",
		},
		{
			"<leader>ob",
			'<cmd>lua require("opencode").prompt("@buffer", { append = true })<cr>',
			desc = "Add buffer to prompt",
		},
		{
			"<leader>op",
			'<cmd>lua require("opencode").prompt("@selection", { append = true })<cr>',
			mode = "v",
			desc = "Add selection to prompt",
		},
		{ "<leader>on", '<cmd>lua require("opencode").command("session_new")<cr>', desc = "New session" },
		{ "<leader>os", '<cmd>lua require("opencode").select()<cr>', mode = { "n", "v" }, desc = "Select prompt" },
	},
	config = function()
		vim.g.opencode_opts = {
			-- Your configuration, if any — see `lua/opencode/config.lua`
		}

		-- Required for `opts.auto_reload`
		vim.opt.autoread = true

		-- Buffer-local scroll mappings for opencode terminal window only
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "opencode_terminal",
			callback = function(args)
				-- Use <C-u>/<C-d> to scroll messages half page up/down within opencode terminal
				local opts = { silent = true, buffer = args.buf }
				vim.keymap.set("n", "<C-u>", '<cmd>lua require("opencode").command("messages_half_page_up")<cr>', opts)
				vim.keymap.set(
					"n",
					"<C-d>",
					'<cmd>lua require("opencode").command("messages_half_page_down")<cr>',
					opts
				)

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
