-- Telescope.
return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"rcarriga/nvim-notify",
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		})

		local builtin = require("telescope.builtin")

		vim.keymap.set({ "n", "i" }, "<A-p>", builtin.git_files, {})
		vim.keymap.set({ "n", "i" }, "<C-p>", builtin.find_files, {})
		vim.keymap.set({ "n", "i" }, "<C-f>", builtin.live_grep, {})
		vim.keymap.set({ "n", "i" }, "<A-f>", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>?", "<Cmd>Telescope<CR>")
		vim.keymap.set("n", "<leader>M", "<Cmd>Telescope notify<CR>")

		telescope.load_extension("fzf")
	end,
}
