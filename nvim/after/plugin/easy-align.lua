-- Set keymap for easy align.
vim.keymap.set("n", "<leader>ea", function()
	vim.cmd.LiveEasyAlign()
	print(" ") -- clear the status message
end)
vim.keymap.set("v", "<leader>ea", function()
	vim.cmd.LiveEasyAlign()
	print(" ") -- clear the status message
end)
