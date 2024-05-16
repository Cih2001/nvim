return {
	settings = {
		gopls = {
			usePlaceholders = true,
			gofumpt = true,
			buildFlags = { "-tags=it unsafe test_integration" },
			codelenses = {
				test = true,
			},
		},
	},
}
