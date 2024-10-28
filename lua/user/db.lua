local function load_module(module_name)
	local ok, module = pcall(require, module_name)
	assert(ok, string.format("dependency error: %s not installed", module_name))
	return module
end
load_module("cmp")

vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_execute_on_save = 0
vim.g.db_ui_win_position = "right"
vim.cmd([[
      autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
      " Source is automatically added, you just need to include it in the chain complete list
      let g:completion_chain_complete_list = {
          \   'sql': [
          \    {'complete_items': ['vim-dadbod-completion']},
          \   ],
          \ }
      " Make sure `substring` is part of this list. Other items are optional for this completion source
      let g:completion_matching_strategy_list = ['exact', 'substring']
      " Useful if there's a lot of camel case items
      let g:completion_matching_ignore_case = 1
      ]])
vim.cmd([[
let g:db_ui_table_helpers = {
\   'postgresql': {
\     'All Info': "select * from information_schema.columns where table_name='{table}' and table_schema='{schema}';\n
\select * from pg_indexes where tablename='{table}' and schemaname='{schema}';\n
\select tc.constraint_name as foreign_keys, tc.table_name, kcu.column_name, ccu.table_name as foreign_table_name, ccu.column_name as foreign_column_name, rc.update_rule, rc.delete_rule\n
      \from\n
      \     information_schema.table_constraints as tc\n
      \     join information_schema.key_column_usage as kcu\n
      \       on tc.constraint_name = kcu.constraint_name\n
      \     join information_schema.referential_constraints as rc\n
      \       on tc.constraint_name = rc.constraint_name\n
      \     join information_schema.constraint_column_usage as ccu\n
      \       on ccu.constraint_name = tc.constraint_name\n
      \where constraint_type = 'FOREIGN KEY'\nand tc.table_name = '{table}'\nand tc.table_schema = '{schema}';\n
\select tc.constraint_name as references, tc.table_name, kcu.column_name, ccu.table_name as foreign_table_name, ccu.column_name as foreign_column_name, rc.update_rule, rc.delete_rule\n
      \from\n
      \     information_schema.table_constraints as tc\n
      \     join information_schema.key_column_usage as kcu\n
      \       on tc.constraint_name = kcu.constraint_name\n
      \     join information_schema.referential_constraints as rc\n
      \       on tc.constraint_name = rc.constraint_name\n
      \     join information_schema.constraint_column_usage as ccu\n
      \       on ccu.constraint_name = tc.constraint_name\n
      \where constraint_type = 'FOREIGN KEY'\nand ccu.table_name = '{table}'\nand tc.table_schema = '{schema}';\n
\select tc.constraint_name as primary_key, tc.table_name, kcu.column_name\n
      \from\n
      \     information_schema.table_constraints as tc\n
      \     join information_schema.key_column_usage as kcu\n
      \       on tc.constraint_name = kcu.constraint_name\n
      \where constraint_type = 'PRIMARY KEY'\nand tc.table_name = '{table}'\nand tc.table_schema = '{schema}';"
\   }
\ }
]])
