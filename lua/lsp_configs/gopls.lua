return {
	settings = {
		gopls = {
			usePlaceholders = true,
			gofumpt = true,
			buildFlags = { "-tags=it unsafe test_integration it_e2e" },
			codelenses = {
				test = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				functionTypeParameters = true,
				parameterNames = true,
			},
		},
	},
}
