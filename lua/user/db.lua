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
\select conrelid::regclass as table_from,\n
\       conname,\n
\       pg_get_constraintdef(oid)\n
\from pg_constraint\n
\where conrelid::regclass::text = '{schema}.{table}'\n
\order by conrelid::regclass::text, contype desc;"
\   }
\ }
]])
