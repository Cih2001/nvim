return {
  settings = {
    gopls = {
      usePlaceholders = true,
      gofumpt = true,
      buildFlags = {"-tags=it stress_test"},
    },
  },
}
