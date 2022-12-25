local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
	ignore_install = { "" }, -- List of parsers to ignore installing
	autopairs = {
		enable = true,
	},
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "" }, -- list of language that will be disabled
		additional_vim_regex_highlighting = true,
	},
	indent = { enable = true, disable = { "yaml" } },
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<c-space>",
			node_incremental = "<c-space>",
			scope_incremental = "<c-s>",
			node_decremental = "<c-backspace>",
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]]"] = "@function.outer",
			},
			goto_next_end = {
				["]["] = "@function.outer",
			},
			goto_previous_start = {
				["[["] = "@function.outer",
			},
			goto_previous_end = {
				["[]"] = "@function.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["ss"] = "@parameter.inner",
			},
			swap_previous = {
				["sd"] = "@parameter.inner",
			},
		},
	},
})

vim.cmd("set foldmethod=expr")
vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
vim.cmd("set nofoldenable")

local api = vim.api
-- function to create a list of commands and convert them to autocommands
-------- This function is taken from https://github.com/norcalli/nvim_utils
local function nvim_create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		api.nvim_command("augroup " .. group_name)
		api.nvim_command("autocmd!")
		for _, def in ipairs(definition) do
			local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
			api.nvim_command(command)
		end
		api.nvim_command("augroup END")
	end
end

local autoCommands = {
	open_folds = {
		{ "BufWinEnter,BufReadPost,FileReadPost", "*", "normal zR" },
	},
}

nvim_create_augroups(autoCommands)
