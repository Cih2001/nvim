local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.keymap.set("n", "K", '<cmd>lua vim.lsp.buf.hover({ border = "rounded"})<CR>', opts)
	vim.keymap.set({ "n", "v", "x" }, "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	vim.keymap.set("n", "[c", "<cmd>lua vim.diagnostic.jump({count=-1})<CR>", opts)
	vim.keymap.set("n", "]c", "<cmd>lua vim.diagnostic.jump({count=1})<CR>", opts)
end

local function on_attach(client, bufnr)
	lsp_keymaps(bufnr)
	local ill = require("illuminate")
	ill.on_attach(client)
end

local function build_key(tbl)
	return tbl.lnum .. ":" .. tbl.bufnr
end

local function diagnostics_map(diagnostics)
	local memo = {}
	for index, value in ipairs(diagnostics) do
		if memo[build_key(value)] == nil then
			memo[build_key(value)] = { index }
		else
			table.insert(memo[build_key(value)], index)
		end
	end
	return memo
end

local function setup_diagnostics()
	-- Hook the virtual line handler. We do not want to show
	-- virtual lines if there is only one item on the line.
	local org_handler = vim.diagnostic.handlers.virtual_lines
	vim.diagnostic.handlers.virtual_lines = {
		show = function(namespace, bufnr, diagnostics, opts)
			local memo = diagnostics_map(diagnostics)
			local new_list = {}
			for _, value in pairs(memo) do
				if #value > 1 then
					for _, idx in ipairs(value) do
						table.insert(new_list, diagnostics[idx])
					end
				end
			end
			org_handler.show(namespace, bufnr, new_list, opts)
		end,
		hide = function(ns, bufnr)
			org_handler.hide(ns, bufnr)
		end,
	}

	vim.diagnostic.config({
		virtual_text = true,
		virtual_lines = { current_line = true },
		-- show signs
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.INFO] = "",
				[vim.diagnostic.severity.HINT] = "",
			},
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = false,
	})
end

return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"RRethy/vim-illuminate",
		},
		config = function()
			local mason = require("mason")
			local lspconfig = require("lspconfig")

			setup_diagnostics()
			-- enable mason
			mason.setup()

			local server_configs = {
				"gopls",
				"lua_ls",
				"buf_ls",
			}

			for _, server in pairs(server_configs) do
				local opts = { on_attach = on_attach }
				local has_custom_opts, server_custom_opts = pcall(require, "lsp_configs." .. server)
				if has_custom_opts then
					opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
				end
				lspconfig[server].setup(opts)
			end
		end,
	},
	{
		"smjonas/inc-rename.nvim",
		config = function()
			require("inc_rename").setup()
		end,
		keys = { { "<leader>rn", ":IncRename " } },
	},
	{
		"RRethy/vim-illuminate",
		keys = {
			-- Illuminate --
			-- c-[ has the same char code as esc. It can be remapped in neovim, if your terminal
			-- supports extended keys and  both keys are mapped. :help <Tab>.
			--
			-- Kitty supports extended keys but it has its own protocol that tmux doesn't support yet:
			-- https://github.com/tmux/tmux/issues/4196
			-- Therefore we need a workaround: In your kitty config (.config/kitty/kitty.conf) remap
			-- C-[ to A-j by the following command
			--
			-- map ctrl+[ send_key alt+j
			--
			-- and create a map for alt-j:
			{
				"<C-]>",
				function()
					require("illuminate").next_reference({ wrap = true })
					vim.cmd(":normal! zz")
				end,
			},
			{
				"<A-j>",
				function()
					require("illuminate").next_reference({ reverse = true, wrap = true })
					vim.cmd(":normal! zz")
				end,
			},
		},
	},
}
