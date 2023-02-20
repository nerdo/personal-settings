local present, symbols_outline = pcall(require, "symbols-outline")

if not present or vim.g.vscode then
	return
end

symbols_outline.setup({
	auto_close = true,
	show_numbers = true,
	show_relative_numbers = true,
	keymaps = {
		hover_symbol = "K",
		toggle_preview = "P",
	},
})

vim.keymap.set("n", "<leader>o", ":SymbolsOutline<CR>", {})
