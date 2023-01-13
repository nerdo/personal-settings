local present, saga = pcall(require, "lspsaga")

if not present or vim.g.vscode then
	return
end

saga.setup({
	border_style = "bold",
	code_action_lightbulb = {
		enable = false,
	},
	show_outline = {
		win_width = 50,
	},
})
