if not vim.g.loaded_dirvish then
	return
end

-- Set keybindings
vim.keymap.set("n", "<leader>f", "<Cmd>Dirvish<CR>")
