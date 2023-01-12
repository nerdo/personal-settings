if not vim.g.loaded_dirvish or vim.g.vscode then
	return
end

-- Set keybindings
vim.keymap.set("n", "<leader>f", "<Cmd>Dirvish<CR>")
