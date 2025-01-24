-- LSP saga (enhanced LSP functionality).
if vim.g.nerdo_is_headless then
	return {}
end

return {
	"nvimdev/lspsaga.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local lspsaga = require("lspsaga")

		lspsaga.setup({
			finder = {
				keys = {
					toggle_or_open = "<CR>",
					vsplit = "|",
					split = "-",
					quit = { "<esc>", "<C-c>" },
				},
			},
			rename = {
				keys = {
					quit = { "<esc>", "<C-c>" },
				},
			},
			code_action = {
				keys = {
					quit = { "<esc>", "<C-c>" },
				},
			},
			diagnostic = {
				show_code_action = false,
				jump_num_shortcut = false,
				keys = {
					quit = { "<esc>", "<C-c>" },
				},
			},
			hover = {
				open_browser = "!firefox",
			},
			ui = {
				border = "solid",
			},
		})

		-- Keymaps are set in mason.
	end,
}
