local present, autopairs = pcall(require, "nvim-autopairs")
if not present or vim.g.vscode then
	return
end

autopairs.setup({})
