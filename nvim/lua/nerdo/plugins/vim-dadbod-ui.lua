-- Database tools.
return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		"tpope/vim-dadbod",
		"kristijanhusak/vim-dadbod-completion",
	},
	config = function()
		vim.keymap.set("n", "<leader>Db", ":DBUIToggle<CR>")
		vim.keymap.set("n", "<leader>Df", ":DBUIFindBuffer<CR>")
		vim.keymap.set("n", "<leader>Dr", ":DBUIRenameBuffer<CR>")
		vim.keymap.set("n", "<leader>Dq", ":DBUILastQueryInfo<CR>")
	end
}
