-- Debug adapter.
if vim.g.nerdo_is_headless then
	return {}
end

return {
	"theHamsta/nvim-dap-virtual-text",
	dependencies = {
		"mfussenegger/nvim-dap",
	},
	enabled = function()
		return not vim.g.vscode
	end,
	config = function()
		require("nvim-dap-virtual-text").setup()
	end,
}
