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
\     'List': "select * from {schema}.{table} limit 2;",
\     'Columns': "",
\     'Primary Keys': "",
\     'Indexes': "",
\     'References': "",
\     'Foreign Keys': "",
\     'Info': "select format('%s.%s', table_schema, table_name) as tablename,  column_name, column_default, is_nullable, data_type\n
\from information_schema.columns where table_name='{table}' and table_schema='{schema}' order by ordinal_position asc;\n
\select format('%s.%s', schemaname, tablename) as tablename, indexname, indexdef from pg_indexes where tablename='{table}' and schemaname='{schema}';\n
\select conrelid::regclass as tablename, conname, pg_get_constraintdef(oid) from pg_constraint\n
\where conrelid::regclass::text = '{schema}.{table}' order by contype desc;\n
\select conrelid::regclass as dependancies, conname, pg_get_constraintdef(oid) from pg_constraint\n
\where confrelid::regclass::text = '{schema}.{table}'order by contype desc;"
\   }
\ }
]])

vim.cmd([[
let g:db_ui_icons = {
    \ 'expanded': '',
    \ 'collapsed': '',
    \ }
]])

return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = { "tpope/vim-dadbod", "kristijanhusak/vim-dadbod-completion" },
	lazy = true,
	cmd = "DBUI",
}
