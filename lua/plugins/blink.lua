return {
	"saghen/blink.cmp",
	-- use a release tag to download pre-built binaries
	version = "*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	opts = {
		keymap = {
			preset = "none",
			["<CR>"] = { "select_and_accept", "fallback" },
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
			["<S-k>"] = { "show_signature", "hide_signature", "fallback" }, -- press K again to jump into the window and scroll
			["<C-j>"] = {
				function(cmp)
					if cmp.snippet_active() then
						return cmp.snippet_forward()
					end
				end,
				"select_next",
				"fallback",
			},
			["<C-k>"] = {
				function(cmp)
					if cmp.snippet_active() then
						return cmp.snippet_backward()
					end
				end,
				"select_prev",
				"fallback",
			},
		},
		cmdline = {
			enabled = false,
		},
		completion = {
			list = {
				selection = {
					preselect = false,
				},
			},
			menu = {
				draw = {
					columns = {
						{ "kind_icon" },
						{ "label" },
						{ "source_name" },
					},
				},
			},
			-- Show documentation when selecting a completion item
			documentation = {
				auto_show = true,
			},

			-- Display a preview of the selected item on the current line
			ghost_text = { enabled = true },
		},
		appearance = {
			-- Sets the fallback highlight groups to nvim-cmp's highlight groups
			-- Useful for when your theme doesn't support blink.cmp
			-- Will be removed in a future release
			use_nvim_cmp_as_default = true,
			-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lsp", "path", "buffer" },
			per_filetype = {
				sql = { "snippets", "dadbod", "buffer" },
			},
			-- add vim-dadbod-completion to your completion providers
			providers = {
				dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
			},
		},

		-- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
