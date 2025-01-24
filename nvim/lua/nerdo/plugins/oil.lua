-- File explorer.
if vim.g.nerdo_is_headless then
	return {}
end

return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local oil = require("oil")
		oil.setup({
			view_options = {
				show_hidden = true,
			},
		})

		-- Set keybindings
		vim.keymap.set("n", "-", "<Cmd>Oil<CR>")
		vim.keymap.set("n", "<leader>f", function()
			vim.cmd("Oil " .. vim.fn.getcwd())
		end)
	end,
}
