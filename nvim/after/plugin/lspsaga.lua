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

		-- Outline specific keymaps.
		local bufnr = vim.api.nvim_get_current_buf()
		local keymap_options = { silent = true, buffer = bufnr }
		vim.keymap.set("n", "<leader>m", "/ Method<cr><cmd>nohl<cr>", keymap_options)
		vim.keymap.set("n", "<leader>f", "/ Function<cr><cmd>nohl<cr>", keymap_options)
		vim.keymap.set("n", "<leader>i", "/ Interface<cr><cmd>nohl<cr>", keymap_options)
	end,
})
