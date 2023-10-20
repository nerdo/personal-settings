-- Auto pairing of brackets and such.
return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	enabled = function()
		return not vim.g.vscode
	end,
	opts = {}, -- equivalent to calling setup({}) function
}
