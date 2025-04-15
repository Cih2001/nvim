return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "davesavic/dadbod-ui-yank" },
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	init = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_execute_on_save = 0
		vim.g.db_ui_win_position = "right"
		vim.g.db_ui_icons = { expanded = "", collapsed = "" }
		vim.g.vim_dadbod_completion_lowercase_keywords = 1
		vim.g.db_ui_table_helpers = {
			postgresql = {
				List = "select * from {schema}.{table} limit 2;",
				Columns = "",
				["Primary Keys"] = "",
				Indexes = "",
				References = "",
				["Foreign Keys"] = "",
				Info = [[
select format('%s.%s', table_schema, table_name) as tablename, column_name, column_default, is_nullable, data_type
from information_schema.columns where table_name='{table}' and table_schema='{schema}' order by ordinal_position asc;
select format('%s.%s', schemaname, tablename) as tablename, indexname, indexdef from pg_indexes where tablename='{table}' and schemaname='{schema}';
select conrelid::regclass as tablename, conname, pg_get_constraintdef(oid) from pg_constraint
where conrelid::regclass::text = '{schema}.{table}' order by contype desc;
select conrelid::regclass as dependancies, conname, pg_get_constraintdef(oid) from pg_constraint
where confrelid::regclass::text = '{schema}.{table}' order by contype desc;
]],
			},
		}

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "sql",
			callback = function()
				local opts = { noremap = true, silent = true }
				vim.api.nvim_buf_set_keymap(0, "n", "<Leader>e", "<Plug>(DBUI_EditBindParameters)", opts)
				vim.api.nvim_buf_set_keymap(0, "n", "<Leader>s", "<Plug>(DBUI_ExecuteQuery)", opts)
				vim.api.nvim_buf_set_keymap(0, "n", "<Leader>w", "<Plug>(DBUI_SaveQuery)", opts)
			end,
		})

		require("dadbod-ui-yank").setup()
	end,
	lazy = true,
	cmd = "DBUI",
}
