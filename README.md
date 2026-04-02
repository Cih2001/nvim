# nvim config

Personal Neovim configuration built on [lazy.nvim](https://github.com/folke/lazy.nvim), targeting Go, TypeScript, Python, Lua, Terraform, and C/C++ development.

## Requirements

- **Neovim** >= 0.12
- **[fzf](https://github.com/junegunn/fzf)**
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** — live grep
- **[Nerd Font](https://www.nerdfonts.com/)** — icons in the UI
- **[gh](https://cli.github.com/)** — GitHub CLI (Octo, PR env action)

**Language tooling** (installable via Mason or system package manager):

| Tool                    | Purpose                       |
| ----------------------- | ----------------------------- |
| `gopls`                 | Go LSP                        |
| `dlv`                   | Go debugger                   |
| `gofumpt` + `goimports` | Go formatting                 |
| `golangci-lint`         | Go linting                    |
| `ts_ls`                 | TypeScript/JavaScript LSP     |
| `eslint_d`              | JS/TS linting                 |
| `prettier`              | JS/TS/MD/JSON/YAML formatting |
| `pylsp`                 | Python LSP                    |
| `lua_ls`                | Lua LSP                       |
| `stylua`                | Lua formatting                |
| `terraform-ls`          | Terraform LSP                 |
| `terraform_fmt`         | Terraform formatting          |
| `clangd` + `codelldb`   | C/C++ LSP and debugger        |
| `buf_ls`                | Protobuf LSP                  |

## Installation

```sh
git clone https://github.com/Cih2001/nvim ~/.config/nvim
nvim
```

On first launch, lazy.nvim bootstraps itself and installs all plugins automatically.

## Plugins

### UI

| Plugin                                          | Purpose                               |
| ----------------------------------------------- | ------------------------------------- |
| `bluz71/vim-moonfly-colors`                     | Active colorscheme (dark)             |
| `nvim-lualine/lualine.nvim`                     | Statusline                            |
| `desdic/marlin.nvim` + `tabline-framework.nvim` | Bookmark-driven tabline (pin buffers) |
| `nvim-tree/nvim-tree.lua`                       | File explorer                         |
| `nvim-tree/nvim-web-devicons`                   | File-type icons                       |
| `lukas-reineke/indent-blankline.nvim`           | Indent guide lines                    |
| `lewis6991/satellite.nvim`                      | Scrollbar with diagnostic decorations |

### LSP & Completion

| Plugin                    | Purpose                                        |
| ------------------------- | ---------------------------------------------- |
| `neovim/nvim-lspconfig`   | LSP client configs                             |
| `williamboman/mason.nvim` | LSP/DAP/linter/formatter installer             |
| `saghen/blink.cmp`        | Completion engine (fuzzy, ghost text)          |
| `smjonas/inc-rename.nvim` | Live incremental LSP rename                    |
| `RRethy/vim-illuminate`   | Highlight all occurrences of word under cursor |

### Treesitter

| Plugin                                        | Purpose                               |
| --------------------------------------------- | ------------------------------------- |
| `nvim-treesitter/nvim-treesitter`             | Syntax highlighting and folding       |
| `nvim-treesitter/nvim-treesitter-textobjects` | Function/parameter/class text objects |

Installed parsers: `c`, `lua`, `vim`, `vimdoc`, `cpp`, `python`, `go`, `hcl`, `yaml`

### Fuzzy Finder

| Plugin             | Purpose                                                             |
| ------------------ | ------------------------------------------------------------------- |
| `ibhagwan/fzf-lua` | Files, grep, buffers, LSP, git, diagnostics, marks, registers, help |

### Editing

| Plugin                   | Purpose                             |
| ------------------------ | ----------------------------------- |
| `windwp/nvim-autopairs`  | Auto-close brackets, parens, quotes |
| `mg979/vim-visual-multi` | Multi-cursor editing                |
| `stevearc/conform.nvim`  | Format on save                      |
| `mfussenegger/nvim-lint` | Async linting                       |

### Git

| Plugin                    | Purpose                                |
| ------------------------- | -------------------------------------- |
| `lewis6991/gitsigns.nvim` | Hunk signs, navigation, inline preview |
| `FabijanZulj/blame.nvim`  | Full-file git blame view               |
| `sindrets/diffview.nvim`  | Diff and merge view                    |
| `pwntester/octo.nvim`     | GitHub PRs and issues inside Neovim    |

### Debugging

| Plugin                            | Purpose                               |
| --------------------------------- | ------------------------------------- |
| `mfussenegger/nvim-dap`           | Debug Adapter Protocol client         |
| `igorlfs/nvim-dap-view`           | DAP UI (watches, breakpoints, scopes) |
| `theHamsta/nvim-dap-virtual-text` | Inline variable values during debug   |

### Database

| Plugin                                 | Purpose                       |
| -------------------------------------- | ----------------------------- |
| `tpope/vim-dadbod`                     | Database backend              |
| `kristijanhusak/vim-dadbod-ui`         | Database browser UI (`:DBUI`) |
| `kristijanhusak/vim-dadbod-completion` | SQL completions               |
| `davesavic/dadbod-ui-yank`             | Yank query results            |

### Tools & Integrations

| Plugin                           | Purpose                                      |
| -------------------------------- | -------------------------------------------- |
| `christoomey/vim-tmux-navigator` | Seamless Neovim/tmux pane navigation         |
| `NickvanDyke/opencode.nvim`      | OpenCode AI assistant (embedded terminal)    |
| `iamcco/markdown-preview.nvim`   | Live browser preview for Markdown            |
| `Cih2001/pikchr.nvim`            | Pikchr diagram rendering (`:Pikchr`)         |
| `folke/snacks.nvim`              | Input widgets (used by inc-rename, opencode) |

## Key Mappings

### Navigation & Windows

| Key                          | Action                           |
| ---------------------------- | -------------------------------- |
| `<C-h/j/k/l>`                | Move between splits / tmux panes |
| `<Up>/<Down>/<Left>/<Right>` | Resize splits                    |
| `+`                          | Maximise current window width    |
| `=`                          | Equalise window widths           |
| `<C-d>` / `<C-u>`            | Scroll half-page, centred        |
| `n` / `N`                    | Next/prev search result, centred |
| `j` / `k`                    | Move by visual (wrapped) lines   |
| `<C-z>`                      | Toggle file explorer             |

### Fuzzy Finder (`<space>`)

| Key        | Action                |
| ---------- | --------------------- |
| `<space>f` | Find files            |
| `<space>g` | Live grep             |
| `<space>b` | Buffers               |
| `<space>o` | LSP document symbols  |
| `<space>s` | LSP workspace symbols |
| `<space>a` | Workspace diagnostics |
| `<space>j` | Jump list             |
| `<space>c` | Grep current buffer   |
| `<space>r` | Registers             |
| `<space>h` | Help tags             |
| `<space>v` | Bookmark list         |
| `<space>p` | GitHub PRs (Octo)     |

### LSP

| Key               | Action                          |
| ----------------- | ------------------------------- |
| `gd`              | Go to definition                |
| `gD`              | Go to declaration               |
| `gr`              | References                      |
| `gi`              | Implementations                 |
| `gy`              | Type definitions                |
| `gf`              | LSP finder                      |
| `<leader>a`       | Code action                     |
| `<leader>rn`      | Incremental rename              |
| `[c` / `]c`       | Prev/next diagnostic            |
| `<C-]>` / `<A-j>` | Next/prev illuminated reference |

### Git

| Key          | Action                |
| ------------ | --------------------- |
| `]g` / `[g`  | Next/prev hunk        |
| `<leader>gp` | Preview hunk inline   |
| `<leader>gs` | Git status (fzf)      |
| `<leader>gb` | Git branches (fzf)    |
| `<leader>gc` | Git commits (fzf)     |
| `<leader>q`  | Toggle git blame view |

### Bookmarks & Tabs (Marlin)

| Key               | Action                             |
| ----------------- | ---------------------------------- |
| `,`               | Add current file to bookmarks      |
| `<S-l>` / `<S-h>` | Next/prev bookmark                 |
| `<S-q>`           | Remove current file from bookmarks |

### Debugger (DAP)

| Key    | Action                 |
| ------ | ---------------------- |
| `<F1>` | Toggle DAP view        |
| `<F2>` | Toggle breakpoint      |
| `<F3>` | Conditional breakpoint |
| `<F4>` | Run to cursor          |
| `<F5>` | Continue               |
| `<F6>` | Step over              |
| `<F7>` | Step into              |
| `<F8>` | Step out               |

### Treesitter Text Objects

| Key         | Mode            | Action                        |
| ----------- | --------------- | ----------------------------- |
| `af` / `if` | Visual/Operator | Outer/inner function          |
| `ac` / `ic` | Visual/Operator | Outer/inner class             |
| `aa` / `ia` | Visual/Operator | Outer/inner parameter         |
| `]]` / `[[` | Normal          | Next/prev function start      |
| `][` / `[]` | Normal          | Next/prev function end        |
| `]a` / `[a` | Normal          | Next/prev parameter           |
| `ss` / `sd` | Normal          | Swap with next/prev parameter |

### AI (OpenCode)

| Key          | Action                   |
| ------------ | ------------------------ |
| `<leader>ot` | Toggle OpenCode terminal |
| `<leader>oa` | Ask about selection      |
| `<leader>ob` | Add buffer to prompt     |
| `<leader>os` | Select prompt            |

### Misc

| Key         | Action                                         |
| ----------- | ---------------------------------------------- |
| `<leader>t` | Open action menu (test / GitHub link / PR env) |
| `<leader>w` | Toggle line wrap                               |
| `z=`        | Spell suggestions (fzf)                        |
| `J` / `K`   | Move selected lines up/down (visual)           |

## Custom Features

### Go Test Runner (`lua/gotest.lua`)

Bound to the action menu (`<leader>t` → Run test). Uses Treesitter to find the nearest test function (including test suite methods), parses `//go:build` tags from the file header, and runs the test in a floating terminal:

```
go test -v -p 1 -count=1 -run <TestName> -tags="..."
```

### Developer Action Menu (`lua/custom.lua`)

`<leader>t` opens a picker with three actions:

- **Run test** — runs the nearest Go test via `gotest.lua`
- **GitHub Link** — constructs and opens a permalink to the exact file + line in the browser
- **Open PR Env** — uses `gh pr view` to find the PR number and opens its preview deployment URL

### Bitcoin Price Widget (`lua/bitcoin.lua`)

Fetches the live BTC/USDT price from the Binance REST API every 60 seconds (via `vim.uv` timer) and displays it in the right section of the statusline.

### Custom Tabline (`lua/plugins/marlin.lua`)

Built on `marlin.nvim` + `tabline-framework.nvim`. Shows bookmarked files as tabs with icons and modified indicators. Resolves duplicate filenames by showing progressively more parent directories until unique.

### Diagnostic Virtual Lines (`lua/plugins/lsp.lua`)

Overrides the default virtual lines handler to only show virtual lines when a line has more than one diagnostic, keeping single-diagnostic lines uncluttered.

### Context-Aware DAP Config (`lua/dap_configs/`)

At startup the DAP plugin checks the current working directory. If it matches a known project, it loads a project-specific config — in this case a Delve remote-attach setup for Okteto with local↔container path substitution.
