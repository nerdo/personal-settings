-- REST tools (Postman alternative).
return {
	"rest-nvim/rest.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local rest = require("rest-nvim")

		rest.setup({})

		vim.keymap.set("n", "<leader>rr", "<Plug>RestNvim", { silent = true })
		vim.keymap.set("n", "<leader>rp", "<Plug>RestNvimPreview", { silent = true })
		vim.keymap.set("n", "<leader>rR", "<Plug>RestNvimLast", { silent = true })
	end,
}
