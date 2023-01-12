local present, telescope = pcall(require, "telescope")

if not present then
	return
end

telescope.setup()

local builtin = require("telescope.builtin")

vim.keymap.set({ "n", "i" }, "<C-g>", builtin.git_files, {})
vim.keymap.set({ "n", "i" }, "<C-p>", builtin.find_files, {})
vim.keymap.set({ "n", "i" }, "<C-f>", builtin.live_grep, {})
vim.keymap.set("n", "<leader>?", "<Cmd>Telescope<CR>")

if pcall(require, "telescope._extensions.ui-select") then
	telescope.load_extension("ui-select")
end
