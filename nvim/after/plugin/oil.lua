local present, oil = pcall(require, "oil")

if not present then
	return
end

oil.setup()

-- Set keybindings
vim.keymap.set("n", "-", "<Cmd>Oil<CR>")
