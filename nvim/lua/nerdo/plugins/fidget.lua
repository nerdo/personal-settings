-- UI for nvim-lsp's progress handler.
if vim.g.nerdo_is_headless then
	return {}
end

return {
	"j-hui/fidget.nvim",
	event = "LspAttach",
	opts = {},
}
