local present, lualine = pcall(require, "lualine")

if not present or vim.g.vscode then
	return
end

lualine.setup({
	options = {
		theme = "ayu_dark",
	},
})
