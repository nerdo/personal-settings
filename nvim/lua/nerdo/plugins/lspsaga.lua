-- LSP saga (enhanced LSP functionality).
return {
	'nvimdev/lspsaga.nvim',
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
		'nvim-tree/nvim-web-devicons',
	},
	config = function()
		local lspsaga = require("lspsaga")

		lspsaga.setup({
			finder = {
				keys = {
					toggle_or_open = "<CR>",
					vsplit = "|",
					split = "-",
					quit = { "q", "<esc>", "<C-c>" },
				},
			},
			rename = {
				keys = {
					quit = { "q", "<esc>", "<C-c>" },
				}
			},
			code_action = {
				keys = {
					quit = { "q", "<esc>", "<C-c>" },
				},
			},
			diagnostic = {
				show_code_action = false,
				jump_num_shortcut = false,
				keys = {
					quit = { "q", "<esc>", "<C-c>" },
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
	end
}
