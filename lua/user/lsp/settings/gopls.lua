return {
	settings = {
		gopls = {
			usePlaceholders = true,
			gofumpt = true,
			buildFlags = { "-tags=it" },
      codelenses = {
        test = true,
      },
		},
	},
}
