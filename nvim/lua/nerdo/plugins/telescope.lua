-- Telescope.
if vim.g.nerdo_is_headless then
	return {}
end

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
			defaults = {
				layout_strategy = 'center',
				layout_config = {
					anchor = "N",
					width = 0.9,
					height = { 0.35, min = 9, max = 11 },
					preview_cutoff = 5,
				}
			},
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		})

		local builtin = require("telescope.builtin")
		local opts = require('telescope.themes').get_ivy({
			cwd = vim.fn.stdpath('config')
		})

		vim.keymap.set({ "n", "i" }, "<A-p>", builtin.git_files, {})
		vim.keymap.set({ "n", "i" }, "<C-p>", builtin.find_files, {})
		vim.keymap.set({ "n", "i" }, "<C-f>", builtin.live_grep, {})
		vim.keymap.set({ "n", "i" }, "<A-f>", builtin.live_grep, {})
		vim.keymap.set({ "n", "i" }, "<leader>,", function()
			-- edit neovim configuration from anywhere
			builtin.find_files {
				cwd = vim.fn.stdpath("config")
			}
		end, {})
		vim.keymap.set("n", "<leader>?", "<Cmd>Telescope<CR>")
		vim.keymap.set("n", "<leader>M", "<Cmd>Telescope notify<CR>")

		telescope.load_extension("fzf")
	end,
}
