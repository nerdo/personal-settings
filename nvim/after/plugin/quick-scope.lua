-- Toggle quick scope
vim.keymap.set({ "n", "x" }, "<leader><leader>", "<Cmd>QuickScopeToggle<CR>")

-- Turn it off by default.
vim.g.qs_enable = false
