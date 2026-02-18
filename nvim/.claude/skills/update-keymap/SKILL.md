---
name: update-keymap
description: >
  Regenerate KEYMAP.md after keymaps are added, removed, or modified.
  Invoke this proactively whenever lua files containing vim.keymap.set,
  keys, or map() calls are edited in this Neovim configuration.
---

# Update Keymap Reference

Regenerate the `KEYMAP.md` keymap reference at the project root.

## Source files

Read ALL of these to extract every keybinding:

- `lua/nerdo/keymap.lua` — core keymaps (leader, quitting, saving, buffers, windows, text manipulation)
- `lua/nerdo/quickfix.lua` — quickfix toggle
- `lua/nerdo/workspace.lua` — session save
- `lua/nerdo/gui/neovide-font-sizing.lua` — Neovide font sizing
- `lua/nerdo/plugins/*.lua` — every plugin file (telescope, gitsigns, mason, trouble, flash, oil, aerial, nvim-dap, nvim-dap-ui, neotest, multiterm, claudecode, lazygit, git-worktree, kulala, vim-dadbod-ui, LuaSnip, treesj, nvim-treesitter.lua, nvim-treesitter-textobjects.lua)

## What to extract

Look for these patterns:

- `vim.keymap.set(mode, key, ...)` — direct keymap definitions
- `keys = { { "key", ..., mode = "..." } }` — lazy.nvim plugin spec keys
- `map(mode, key, ...)` — local helper wrappers around vim.keymap.set
- `keymaps = { ["key"] = ... }` — treesitter textobjects config
- `mapping = cmp.mapping.preset.insert({ ... })` — nvim-cmp mappings
- `goto_next_start`, `goto_next_end`, `goto_previous_start`, `goto_previous_end` — treesitter move config

## Output format

1. Read the existing `KEYMAP.md` to match its current structure and style.
2. Preserve the section organization (grouped by feature/plugin).
3. Use markdown tables with columns: Keys | Mode | Description.
4. Use human-readable key names (`Ctrl+`, `Alt+`, `Shift+`, `Meta+`, `Cmd+`).
5. Show the leader key as `,` literally in key combinations.
6. Note the leader key at the top of the file.
7. Write the updated content to `KEYMAP.md` at the project root.
