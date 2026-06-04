# neovim

## Prerequisites

- ripgrep
- nodejs
- go
- prettier
- rust
- stylua
- tree-sitter CLI — required by nvim-treesitter (`main` branch) to compile parsers.
  On macOS, install the separate `tree-sitter-cli` Homebrew formula (`brew install tree-sitter-cli`),
  **not** the `tree-sitter` formula, which ships the library only and provides no `tree-sitter` binary.

## Setup

To set this up, symlink this to the neovim config directory:

```
ln -s ~/personal/settings/nvim ~/.config/nvim
```

Run `nvim` and lazy.nvim should automatically install all of the necessary plugins. There may be some warnings/errors, but for the most part, this is because things tried to load before they were actually present. Ensure that lazy.nvim installs everything, quit, and re-start neovim.
