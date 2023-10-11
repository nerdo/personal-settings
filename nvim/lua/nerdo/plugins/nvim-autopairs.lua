-- Auto pairing of brackets and such.
return {
	"windwp/nvim-autopairs",
	enabled = function()
		return not vim.g.vscode
	end,
}
