local present, telescope = pcall(require, "telescope")

if not present then
	return
end

telescope.setup()

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<C-g>", builtin.git_files, {})
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<C-f>", builtin.live_grep, {})

if pcall(require, "telescope._extensions.ui-select") then
	telescope.load_extension("ui-select")
end
