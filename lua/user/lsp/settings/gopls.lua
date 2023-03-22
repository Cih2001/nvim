return {
	settings = {
		gopls = {
			usePlaceholders = true,
			gofumpt = true,
			buildFlags = { "-tags=it unsafe" },
			codelenses = {
				test = true,
			},
		},
	},
}
