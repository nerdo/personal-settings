local present, toggleterm = pcall(require, "toggleterm")

if not present then
	return
end

toggleterm.setup()

-- Set up some keybindings just for the terminal buffer.
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*",
	callback = function()
		local opts = { buffer = 0 }
		vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], opts)
	end,
})
