if not vim.g.loaded_dirvish or vim.g.vscode then
	return
end

-- Set keybindings
vim.keymap.set("n", "-", "<Cmd>Dirvish<CR>")
vim.keymap.set("n", "<leader>f", function()
	vim.cmd("Dirvish " .. vim.fn.getcwd())
end)
