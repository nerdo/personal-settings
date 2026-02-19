# Neovim Configuration

Personal Neovim configuration managed with lazy.nvim plugin manager.

## Project Structure

```
lua/nerdo/
├── init.lua              # Module initialization
├── lazy.lua              # Lazy plugin manager bootstrap
├── keymap.lua            # Global keybindings (leader = ,)
├── options.lua           # Neovim options
├── functions.lua         # Helper functions
└── plugins/              # One file per plugin
    ├── mason.lua          # LSP servers, completion (nvim-cmp), keymaps
    ├── conform.lua        # Formatters (format-on-save)
    ├── nvim-lint.lua      # Linters (currently disabled)
    └── ...
```

## Plugin Setup Patterns

### Adding an LSP Server

All LSP configuration lives in `lua/nerdo/plugins/mason.lua`.

1. Add the server name to `mason_lspconfig.setup({ ensure_installed = { ... } })`
2. Add a `lspconfig.<server>.setup({})` call below the existing ones
3. If the server needs a specific runtime (e.g., PHP), use an explicit `cmd` pointing to the binary

Example pattern (from phpactor):
```lua
lspconfig.phpactor.setup({
    cmd = {
        "/opt/homebrew/opt/php@8.1/bin/php",
        vim.fn.stdpath("data") .. "/mason/packages/phpactor/phpactor.phar",
        "language-server"
    },
    settings = { ... },
})
```

Key conventions:
- PHP tools use `/opt/homebrew/opt/php@8.1/bin/php` as the runtime
- Mason packages live at `vim.fn.stdpath("data") .. "/mason/packages/<name>/"`
- Keymaps are set in the `LspAttach` autocmd, not per-server
- Diagnostics UI uses lspsaga (virtual text is disabled)

### Adding a Formatter

Formatters are configured in `lua/nerdo/plugins/conform.lua` via `formatters_by_ft`.

```lua
formatters_by_ft = {
    php = { "phpcbf" },
    -- ...
}
```

### Adding a Linter

Linters are configured in `lua/nerdo/plugins/nvim-lint.lua` via `linters_by_ft`. Note: this plugin is currently **disabled** (`enabled = false`) in favor of LSP diagnostics.

### Running Multiple LSP Servers per Language

Neovim supports attaching multiple LSP servers to the same filetype. When adding a second server for a language (e.g., Psalm alongside phpactor), both will attach and provide their respective capabilities (diagnostics, completion, etc.) without conflict.
