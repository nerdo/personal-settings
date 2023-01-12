local present, saga = pcall(require, "lspsaga")

if not present then
	return
end

saga.init_lsp_saga({
	border_style = "bold",
	code_action_lightbulb = {
		enable = false,
	},
	show_outline = {
		win_width = 50,
	},
})
