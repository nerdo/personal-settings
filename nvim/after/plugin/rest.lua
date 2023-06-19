local present, rest = pcall(require, "rest-nvim")

if not present then
	return
end

rest.setup({})

vim.keymap.set("n", "<leader>rr", "<Plug>RestNvim", { silent = true })
vim.keymap.set("n", "<leader>rp", "<Plug>RestNvimPreview", { silent = true })
vim.keymap.set("n", "<leader>rR", "<Plug>RestNvimLast", { silent = true })
