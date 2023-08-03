local present, oil = pcall(require, "oil")

if not present then
	return
end

oil.setup({
	view_options = {
		show_hidden = true
	}
})

-- Set keybindings
vim.keymap.set("n", "-", "<Cmd>Oil<CR>")
vim.keymap.set("n", "<leader>f", function()
	vim.cmd("Oil " .. vim.fn.getcwd())
end)
