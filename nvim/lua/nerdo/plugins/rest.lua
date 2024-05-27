-- REST tools (Postman alternative).
return {
	"rest-nvim/rest.nvim",
	ft = "http",
	dependencies = { "luarocks.nvim" },
	config = function()
		local rest = require("rest-nvim")

		rest.setup({})

		vim.keymap.set("n", "<leader>rr", "<cmd>Rest run<cr>", { silent = true })
		vim.keymap.set("n", "<leader>rR", "<cmd>Rest run last<cr>", { silent = true })
	end,
}
