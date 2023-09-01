local function load_module(module_name)
	local ok, module = pcall(require, module_name)
	assert(ok, string.format("dependency error: %s not installed", module_name))
	return module
end
load_module("cmp")

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
