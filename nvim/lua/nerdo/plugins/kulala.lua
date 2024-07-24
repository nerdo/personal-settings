-- REST tools (Postman alternative).
return {
	"mistweaverco/kulala.nvim",
	config = function()
		local kulala = require("kulala")

		kulala.setup()

		vim.keymap.set("n", "<leader>rr", function()
			kulala.run()
		end, { silent = true })
		vim.keymap.set("n", "<leader>rv", function()
			kulala.toggle_view()
		end, { silent = true })
		vim.keymap.set("n", "<leader>rn", function()
			kulala.jump_next()
		end, { silent = true })
		vim.keymap.set("n", "<leader>rp", function()
			kulala.jump_prev()
		end, { silent = true })
		vim.keymap.set("n", "<leader>rc", function()
			kulala.copy()
		end, { silent = true })
		vim.keymap.set("n", "<leader>re", function()
			kulala.set_selected_env()
		end, { silent = true })
	end,
}
