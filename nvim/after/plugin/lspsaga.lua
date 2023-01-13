local present, saga = pcall(require, "lspsaga")

if not present or vim.g.vscode then
	return
end

saga.setup({
	lightbulb = {
		enable = false,
	},
	outline = {
		win_width = 50,
		keys = {
			jump = "<CR>",
			expand_collapse = "u",
			quit = "<leader>o",
		},
	},
})

local nerdo = require("nerdo.functions")

vim.api.nvim_create_autocmd("FileType", {
	group = nerdo.augroup,
	pattern = "lspsagaoutline",
	callback = function()
		vim.schedule(function()
			vim.cmd("NerdoSetLineNrRelative")
		end)
	end,
})
