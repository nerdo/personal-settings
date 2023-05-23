local present, luasnip = pcall(require, "luasnip")

if not present then
	return
end

vim.keymap.set("i", "<Right>", function()
	luasnip.jump(1)
end, { noremap = true, silent = true })
vim.keymap.set("s", "<Right>", function()
	luasnip.jump(1)
end, { noremap = true, silent = true })
vim.keymap.set("i", "<Left>", function()
	luasnip.jump(-1)
end, { noremap = true, silent = true })
vim.keymap.set("s", "<Left>", function()
	luasnip.jump(-1)
end, { noremap = true, silent = true })
