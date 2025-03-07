return {
	"windwp/nvim-autopairs", -- autoclose parens, brackets, quotes, etc...
	config = function()
		-- import nvim-autopairs safely
		local npairs = require("nvim-autopairs")

		-- configure autopairs
		npairs.setup({
			check_ts = true, -- enable treesitter
			ts_config = {
				lua = { "string" }, -- don't add pairs in lua string treesitter nodes
				javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
			},
		})

		local Rule = require("nvim-autopairs.rule")
		npairs.add_rule(Rule("```", "```"))
	end,
}
